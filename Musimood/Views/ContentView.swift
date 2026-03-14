//
//  ContentView.swift
//  musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView {
                NavigationStack {
                    PlaylistsView()
                        .navigationTitle("Playlists")
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: 60)
                        }
                }
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }
                
                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                
            }
            
            PlayerBar()
                .padding(.horizontal)
                .padding(.bottom, 60)
            
        }
    }
}
