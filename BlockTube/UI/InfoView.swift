//
//  InfoView.swift
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
import ArticleUI

struct InfoView: View {
    @Namespace private var namespace
#if os(iOS) || os(visionOS)
    ///Environment variables used when closing sheets (iOS, iPadOS only)
    @Environment(\.dismiss) private var dismiss
#endif
    ///Environment variable that provides the action to request a review
    @Environment(\.requestReview) var requestReview
    ///Environment variable to use when opening in another window (on macOS only)
    @Environment(\.openWindow) var openWindow
#if !os(macOS)
    ///Value indicating whether the HelpView is open
    @Binding var isOpenHelp: Bool
#endif
    
    let feedBackMail = "mailto:iroiro.work1234@gmail.com?subject=" + (String(localized: "Feedback and requests for BlockTube for Safari").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "feedback")
    
    ///Displayed View
    var body: some View {
        NavigationStack {
            Article {
                Section {
                    Text("To find out what this application can do for you, please see Help.")
                    
                    Button(action: {
#if os(macOS)
                        openWindow(id: "help")
#else
                        isOpenHelp = true
#endif
                    }) {
                        Text("BlockTube for Safari Help")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .matchedTransitionSource(id: "help", in: namespace)
                } header: {
                    Text("Help")
                }
                
                Section {
                    HStack(alignment: .center, spacing: 20) {
                        Text("BlockTube")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .trailing,spacing: 5) {
                            Text("© amitbl")
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
                    HStack(alignment: .center, spacing: 20) {
                        Text("App")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .trailing,spacing: 5) {
                            Text("© 2026 Keisuke Chinone")
                        }
                    }
                    .accessibilityElement(children: .combine)
                } header: {
                    Text("Copyrights")
                }
                .articleRowSeparator(true)
                
                Section {
                    HStack(alignment: .center, spacing: 20) {
                        Text("BlockTube")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .trailing,spacing: 5) {
                            Link(
                                "amitbl and contributors",
                                destination: URL(
                                    string: "https://github.com/amitbl/blocktube/graphs/contributors"
                                )!
                            )
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
                    HStack(alignment: .center, spacing: 20) {
                        Text("SwiftUI")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .trailing,spacing: 5) {
                            Link(
                                "Keisuke Chinone",
                                destination: URL(
                                    string: "https://github.com/KC-2001MS"
                                )!
                            )
                        }
                    }
                    .accessibilityElement(children: .combine)
                } header: {
                    Text("Cooperation and Contribution")
                }
                .articleRowSeparator(true)
                
                Section {
                    Group {
                        Text("If you have any questions or feedback, please contact us at the email address below.")
                        
                        Link("iroiro.work1234@gmail.com",
                             destination: URL(string: feedBackMail)!)
                    }
                    .accessibilityElement(children: .combine)
                } header: {
                    Text("Feedback")
                }
                
                Section {
                    HStack(spacing: 20) {
                        Text("If you like this application, please submit a review.")
                        
#if !os(watchOS) && !os(tvOS)
                        Button(action: {
                            requestReview()
                        }) {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
#endif
                    }
                } header: {
                    Text("Review")
                }
            }
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            .navigationTitle("BlockTube for Safari Info")
#if os(iOS) || os(visionOS)
            .sheet(isPresented: $isOpenHelp, onDismiss: nil) {
                HelpView()
                    .navigationTransition(
                        .zoom(sourceID: "help", in: namespace)
                    )
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
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
    #if !os(macOS)
    InfoView(isOpenHelp: .constant(false))
    #else
    InfoView()
    #endif
}
