//
//  ContentView.swift
//  BlockTube for Safari
//
//  Created by 茅根啓介 on 2023/02/10.
//------------------------------------------
//  GNU General Public License v3.0
//  © 2023 Free Software Foundation, Inc.
//  For more information on the use of the code, please refer to the license

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "testtube.2")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Blocktube Prototype")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
