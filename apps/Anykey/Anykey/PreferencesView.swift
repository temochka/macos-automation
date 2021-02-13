//
//  ContentView.swift
//  Anykey
//
//  Created by Artem Chistyakov on 2/8/21.
//

import SwiftUI

struct PreferencesView: View {
    @State private var configPath: String = "~/.Anykey"

    var body: some View {
        Form {
            Section(header: Text("Config file")) {
                TextField("Path", text: $configPath)
                    .border(Color.secondary)
                Button(action: { return }) {
                    Text("Browse")
                }
            }
        }
            .padding(20)
            .frame(maxWidth: 800, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
