//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var showConfigView = false
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text("收藏")
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar (content: {
                    ToolbarItem(placement: .principal, content: {
                        Text("收藏").font(.headline)
                    })
                })
                .navigationBarItems(trailing: Button(action: {
                    self.showConfigView.toggle()
                }) {
                    Image(systemName: "gear")
                })
                .sheet(isPresented: $showConfigView) {
                    ConfigView()
                }
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
