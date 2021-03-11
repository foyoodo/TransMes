//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 0

    var body: some View {
        TabView(selection : $selection) {
            TransView()
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("小译")
                }.tag(0)

            CollectionView()
                .tabItem {
                    Image(systemName: "star.leadinghalf.fill")
                    Text("收藏")
                }.tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }.tag(2)
        }
    }
}
