//
//  BlockTubeApp.swift
//  BlockTube for Safari
//
//  Created by 茅根啓介 on 2023/02/10.
//------------------------------------------
//  Copyright © 2026 Keisuke Chinone
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License v3.0.
//  This program is distributed WITHOUT ANY WARRANTY.
//  See <https://www.gnu.org/licenses/gpl-3.0.html> for details.

import SwiftUI
#if os(macOS)
import AboutUI
#endif

@main
struct BlockTubeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            HelpCommands()
        }
#if os(macOS)
        .defaultSize(width: 400, height: 600)
#endif
        
#if os(macOS)
        About()
        
        Window("BlockTube for Safari Info", id: "info") {
            InfoView()
        }
        .keyboardShortcut("I", modifiers: [.command, .shift])
        .defaultSize(width: 400, height: 600)
        
        Window("BlockTube for Safari Help", id: "help") {
            HelpView()
        }
        .keyboardShortcut("H", modifiers: [.command, .shift])
        .defaultSize(width: 400, height: 600)
#endif
    }
}
