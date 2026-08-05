//
//  HelpView.swift
//  BlockTube for Safari
//
//  Created by 茅根啓介 on 2026/07/09.
//------------------------------------------
//  Copyright © 2026 Keisuke Chinone
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License v3.0.
//  This program is distributed WITHOUT ANY WARRANTY.
//  See <https://www.gnu.org/licenses/gpl-3.0.html> for details.

import SwiftUI
import ArticleUI

///HelpView displaying what this app can do
struct HelpView: View {
    ///Environment variables used when closing sheets (iOS, iPadOS only)
    @Environment(\.dismiss) private var dismiss
    
    ///Displayed View
    var body: some View {
        NavigationStack {
            Article {
                Section {
                    Text("Hide unwanted videos from YouTube")
                        .foregroundStyle(.gray)
                    
                    Text("BlockTube for Safari hides unwanted videos, channels, and comments on YouTube based on the filters you set.")
                } header: {
                    Text("What is BlockTube for Safari")
                        .bold()
#if !os(watchOS) && !os(tvOS)
                        .font(.largeTitle)
#else
                        .font(.title3)
#endif
                }
                .articleSectionType(style: .title)
                
                Section {
                    Text(
                        "By adding keywords to the filter, videos whose titles contain those keywords are hidden from search results, recommendations, and other YouTube pages."
                    )
                } header: {
                    Text("Block videos by keywords")
                }
                
                Section {
                    Text(
                        "By specifying a channel name or channel ID, all videos from that channel are hidden."
                    )
                } header: {
                    Text("Block channels")
                }
                
                Section {
                    Text(
                        "You can hide comments that contain specific keywords, or hide the entire comment section."
                    )
                } header: {
                    Text("Hide comments")
                }
                
                Section {
                    Text(
                        "You can edit your filters at any time from the extension's settings screen, which opens from the BlockTube button on the Safari toolbar."
                    )
                } header: {
                    Text("Edit filters from the toolbar")
                }
                
                Section {
                    Text(
                        "If you find any problems with this application, please report them via this URL or email."
                    )
                    
                    Link(
                        "Bug Report Page",
                        destination: URL(
                            string: "https://github.com/KC-2001MS/BlockTube-for-Safari/issues"
                        )!
                    )
                } header: {
                    Text("Report bugs")
                }
                
                Section {
                    Text(
                        "You can review the privacy policy for this application at the following site"
                    )
                    
                    Link(
                        "Privacy Policy Page",
                        destination: URL(
                            string: String(localized: "https://kc-2001ms.github.io/en/privacy.html", comment: "Iroiro's Privacy Policy Page")) ?? URL(
                            string: NSLocalizedString(
                                "https://kc-2001ms.github.io/en/",
                                comment: "Iroiro's Top Page"
                            )
                        )!
                    )
                } header: {
                    Text("Privacy Policy")
                }
            }
#if os(iOS)
            .background(Color(.iOSBackground))
#endif
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            .navigationTitle("BlockTube for Safari Help")
#if os(iOS) || os(visionOS)
            .toolbar(id:"help") {
                ToolbarItem(id: "close",placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
#elseif os(macOS)
            .frame(minWidth: 300,minHeight: 400)
#endif
        }
    }
}

#Preview {
    HelpView()
}
