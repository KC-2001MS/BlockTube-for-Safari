# Upstream bug report draft — amitbl/blocktube

投稿先: https://github.com/amitbl/blocktube/issues/new
(上流にはissueテンプレートが存在しないため、GitHub標準のバグレポート形式で作成。以下をそのまま本文として使用できます)

---

**Title:** "Block Channel" / "Block Video" menu items do not respond to touch input on the desktop YouTube UI

## Describe the bug

The injected "Block Channel" and "Block Video" context menu items do not respond when activated by touch (tap) on the desktop YouTube UI (`www.youtube.com`). Tapping the menu item does nothing — no block is registered and the video/channel remains visible.

The same menu items work correctly when activated with a mouse or trackpad on the same device, and touch works correctly on the mobile UI (`m.youtube.com`).

I found this on iPadOS Safari (which loads the desktop YouTube UI by default) while maintaining a Safari port of BlockTube, but the root cause is in the shared content scripts, so any touch-driven session of the desktop UI should be affected (e.g. touchscreen laptops in Chrome/Firefox, Android tablets in desktop mode).

## To Reproduce

1. Open `www.youtube.com` (desktop UI) on a touch device with BlockTube enabled.
2. On any video, tap the ⋮ (three-dot) menu button. The menu opens and the injected "Block Channel" item is visible.
3. Tap "Block Channel" with a finger.
4. Nothing happens: the channel is not added to the block list and its videos are not filtered.
5. Repeat step 3 with a mouse/trackpad pointer → the channel is blocked as expected.
6. Switch to `m.youtube.com` and repeat with touch → blocking works as expected.

## Expected behavior

Tapping "Block Channel" / "Block Video" on the desktop UI should block the channel/video, exactly as clicking it with a mouse does.

## Environment

- OS: iPadOS 26 (also expected on any touch device using the desktop YouTube UI)
- Browser: Safari (Safari Web Extension port of BlockTube; content scripts unmodified in the affected code path)
- BlockTube version: current `master`
- YouTube UI: desktop (`www.youtube.com`) — Polymer app

## Root cause analysis

The menu-item hook relies exclusively on the native `click` event. In `src/scripts/seed.js`, the desktop hook assigns an `onclick` property inside `connectedCallback` of `ytd-menu-service-item-renderer` / `yt-list-item-view-model`:

```js
if (name === 'ytd-menu-service-item-renderer' || name === 'yt-list-item-view-model') {
  let origCallback = constructor.prototype.connectedCallback;
  constructor.prototype.connectedCallback = function() {
    this.onclick = hooks.menuOnTap;
    if (origCallback) origCallback.call(this);
  }
}
```

There is no `touchend` / `pointerup` handling anywhere in the content scripts, so the entire block flow (`menuOnTap` → `postMessage('contextBlockData', …)`) depends on the browser's synthesized `click` reaching the menu item element.

On the desktop UI this never happens for touch input:

- Desktop YouTube's Polymer gesture system handles taps on `touchend` (Polymer `tap` gesture) and closes/tears down the popup menu immediately.
- Polymer's gesture module also installs a "ghost click" canceller — a capture-phase `click` listener on `document` that calls `preventDefault()` + `stopPropagation()` on synthetic clicks following a touch interaction (see Polymer's `mouseCanceller` / `cancelSyntheticClickEvents`).
- As a result, the delayed synthetic `click` either targets an already-detached menu item or is swallowed at the document level, and the `onclick` hook never fires.

With a physical pointer, real `mousedown`/`mouseup`/`click` events are delivered and the canceller is not armed, so the hook works.

This also explains why the mobile UI is unaffected: `m.youtube.com` components handle activation via plain `click` events (no touch-gesture interception layer), so the synthesized `click` from a tap reaches the `onclick` handler assigned in the `ytm-*` custom element hooks.

The reason this went unnoticed is likely that touch + desktop UI is a rare combination on the officially supported platforms (desktop Chrome/Firefox).

## Suggested fix

In the desktop hook in `seed.js`, register an additional activation path alongside `onclick`, e.g. a `pointerup` listener (fires for both touch and mouse; guard against double-invocation when the `click` also arrives), or listen for Polymer's `tap` gesture event on the menu-item elements.

## Additional context

- Verified via code inspection that `seed.js` / `inject.js` / `content_script.js` contain no `touchstart` / `touchend` / `pointerdown` / `pointerup` listeners; the only activation entry points are the `onclick` (and mobile `ondblclick`) property assignments in `seed.js`.
- Workaround for iPad users: disable "Request Desktop Website" for youtube.com so that the mobile UI (`m.youtube.com`) is used, where tapping works.

---

## メモ(このファイル自体の管理用・投稿本文には含めない)

- 作成日: 2026-08-06
- 発見経緯: Safari版(本リポジトリ)で iPad のタップだと Block Channel が反応せず、トラックパッド/マウス操作およびモバイル版サイト表示では動作することから切り分け。
- 該当コード(本リポジトリ内): `BlockTube Extension/Resources/src/scripts/seed.js:253-265`(デスクトップ用フック)、`inject.js:2040`(`menuOnTap`)
- 上流に既存の同種報告なし(iPad / touch / tap で検索済み、2026-08-06 時点)
