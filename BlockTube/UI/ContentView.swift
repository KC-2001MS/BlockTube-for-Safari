//
//  ContentView.swift
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

///The view that appears when the app is opened
struct ContentView: View {
    @Namespace private var namespace
    ///Environment variable to use when opening in another window (on macOS only)
    @Environment(\.openWindow) private var openWindow
    ///Value indicating whether the InfoView is open
    @State private var isOpenInfo = false
    ///Value indicating whether the HelpView is open
    @State private var isOpenHelp = false
    
    ///Displayed View
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading,spacing: 25) {
                    VStack(alignment: .leading,spacing: 15) {
                        Text("How to Activate")
                            .font(.title)
                            .bold()
#if !os(visionOS)
                            .foregroundStyle(Color.accentColor)
#endif
                        VStack(alignment: .leading, spacing: 5) {
                            VStack(alignment: .leading,spacing: 5) {
                                Text("Step 1: Open Safari Settings")
                                    .font(.title2)
                                    .bold()
#if !os(visionOS)
                                    .foregroundStyle(Color.accentColor)
#endif
                                ViewThatFits(in: .horizontal) {
                                    HStack {
                                        Text("Open Safari Settings and go to the Extensions screen or Extensions tab.")
                                            .frame(idealWidth: 400,maxWidth: .infinity,alignment: .leading)

                                        Spacer()

                                        Image("Safari Settings")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                    .frame(height: 400)
                                    .frame(minWidth: 500)

                                    VStack(alignment: .leading) {
                                        Text("Open Safari Settings and go to the Extensions screen or Extensions tab.")

                                        Image("Safari Settings")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text("Step 2: Enable Extensions")
                                    .font(.title2)
                                    .bold()
#if !os(visionOS)
                                    .foregroundStyle(Color.accentColor)
#endif
                                ViewThatFits(in: .horizontal) {
                                    HStack {
                                        Text("Turn on \"BlockTube\" from the Extensions screen or Extensions tab.")
                                            .frame(idealWidth: 400,maxWidth: .infinity,alignment: .leading)

                                        Spacer()

                                        Image("Extention On")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                    .frame(height: 400)
                                    .frame(minWidth: 500)

                                    VStack(alignment: .leading) {
                                        Text("Turn on \"BlockTube\" from the Extensions screen or Extensions tab.")

                                        Image("Extention On")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text("Step 3: Permit Access")
                                    .font(.title2)
                                    .bold()
#if !os(visionOS)
                                    .foregroundStyle(Color.accentColor)
#endif
                                ViewThatFits(in: .horizontal) {
                                    HStack {
                                        Text("From the Access Rights section, allow access to \"youtube.com\".")
                                            .frame(idealWidth: 400,maxWidth: .infinity,alignment: .leading)

                                        Spacer()

                                        Image("Web Permission")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                    .frame(height: 400)
                                    .frame(minWidth: 500)

                                    VStack(alignment: .leading) {
                                        Text("From the Access Rights section, allow access to \"youtube.com\".")

                                        Image("Web Permission")
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(20)
                                            .frame(maxHeight: 400)
                                            .padding()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text("+α The Toolbar Button")
                                    .font(.title2)
                                    .bold()
#if !os(visionOS)
                                    .foregroundStyle(Color.accentColor)
#endif
                                
                                Text("You can open the extension's settings screen from the BlockTube button on the Safari toolbar to edit your filters.")
                                    .frame(idealWidth: 400,maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.regularMaterial, in: .rect(cornerRadius: 30))
                    }
                    
                    VStack(alignment: .leading,spacing: 15) {
                        Text("Extension Source")
                            .font(.title)
                            .bold()
#if !os(visionOS)
                            .foregroundStyle(Color.accentColor)
#endif
                        
                        Text("The source code for the extension is based on the open source project \"BlockTube\" and is used under the GNU General Public License v3.0.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial, in: .rect(cornerRadius: 30))
                    }
                    
                    Divider()
                    
                    Text("1. YouTube is a trademark of Google LLC. This app is an unofficial port and is not affiliated with Google LLC.")
                        .font(.caption)
                }
                .padding()
            }
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            .navigationTitle("BlockTube for Safari")
#if os(iOS) || os(visionOS)
            .sheet(isPresented: $isOpenInfo, onDismiss: nil) {
                InfoView(isOpenHelp: $isOpenHelp)
                    .navigationTransition(
                        .zoom(sourceID: "info", in: namespace)
                    )
            }
            .sheet(isPresented: $isOpenHelp, onDismiss: nil) {
                HelpView()
            }
            .toolbar(id:"iOSToolbar") {
                ToolbarItem(id: "info",placement: .primaryAction) {
                    Button(action: {
                        isOpenInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
#elseif os(macOS)
            .toolbar(id:"macToolbar") {
                ToolbarItem(id: "info",placement: .primaryAction) {
                    Button(action: {
                        openWindow(id: "info")
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .matchedTransitionSource(id: "info", in: namespace)
                }
            }
            .frame(minWidth: 300,idealWidth: 400,minHeight: 400, idealHeight: 600)
            .touchBar {
                Button(action: {
                    openWindow(id: "info")
                }){
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                        .padding(17.5)
                }
                .touchBarItemPresence(.required("questionmarkKey"))
            }
#endif
        }
        .focusedSceneValue(\.isOpenHelp, $isOpenHelp)
    }
}

#Preview {
    ContentView()
}
