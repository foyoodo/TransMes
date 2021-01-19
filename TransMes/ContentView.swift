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
            NavigationView {
                VStack {
                    Text("小译")
                }
                .navigationBarTitle("小译", displayMode: .automatic)
                .navigationBarItems(trailing: NavigationLink(destination: ConfigView()) {
                    Image(systemName: "gear")
                })
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("小译")
            }
            
            NavigationView {
                VStack {
                    Text("收藏")
                }
                .navigationBarTitle("收藏", displayMode: .automatic)
            }
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
