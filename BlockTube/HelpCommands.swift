//
//  HelpCommands.swift
//  BlockTube for Safari
//
//  Created by 茅根啓介 on 2026/08/04.
//------------------------------------------
//  Copyright © 2026 Keisuke Chinone
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License v3.0.
//  This program is distributed WITHOUT ANY WARRANTY.
//  See <https://www.gnu.org/licenses/gpl-3.0.html> for details.

import SwiftUI
import StoreKit

struct HelpCommands: Commands {
    ///Value indicating whether the HelpView is open
    @FocusedBinding(\.isOpenHelp) var isOpenHelp
    ///Environment variable to use when opening in another window (on macOS only)
    @Environment(\.openWindow) private var openWindow
    @Environment(\.requestReview) private var requestReview
    
    let feedBackMail = "mailto:iroiro.work1234@gmail.com?subject=" + (String(localized: "Feedback and requests for BlockTube for Safari").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "feedback")
    
    @MainActor
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Link(destination: URL(string: feedBackMail)!, label: {
                Text("Send feedback to developer via email")
            })
            
            Divider()
            
            Button(action: {
#if os(macOS)
                openWindow(id: "help")
#else
                isOpenHelp!.toggle()
#endif
            }) {
                Text("BlockTube for Safari Help")
            }
#if !os(macOS)
            .disabled(isOpenHelp == nil)
#endif
            .keyboardShortcut("H", modifiers: [.command, .shift])
#if os(macOS)
            Divider()
            
            Button(action: {
                requestReview()
            }) {
                Text("Review BlockTube for Safari in the App Store")
            }
#endif
        }
    }
}
