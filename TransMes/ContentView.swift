//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TransView()
            .tabItem {
                Image(systemName: "note.text")
                Text("小译")
            }
            
            CollectionView()
            .tabItem {
                Image(systemName: "star.fill")
                Text("收藏")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
