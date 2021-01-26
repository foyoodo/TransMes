//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var showConfigView = false
    @State var showSheet = false
    @State var collections: Array<Message> = [
        Message(id: Date().timeIntervalSince1970, time: "2021-01-19 21:01:19", message: "NavigationLink should be inside NavigationView hierarchy. The Menu is outside navigation view, so put buttons inside menu which activate navigation link placed inside navigation view, eg. hidden in background.", result: "NavigationLink 应该位于 NavigationView 层次结构中。菜单是外部导航视图，所以将按钮放在菜单内，激活导航链接放在导航视图内，比如隐藏在背景中。")
    ]
    let generator = UIImpactFeedbackGenerator(style: .soft)
    var body: some View {
        NavigationView {
            List(0..<collections.count) { index in
                NavigationLink(
                    destination:
                        VStack {
                            ScrollView {
                                Text(collections[index].message)
                                Spacer().frame(height: 32)
                                Text(collections[index].result)
                            }
                        }
                        .padding()
                ) {
                    VStack {
                        Text(collections[index].message)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .allowsTightening(true)
                            .minimumScaleFactor(0.5)
                        
                        Text("\(collections[index].time)")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(Color.blue)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .navigationBarTitle("收藏", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSheet, content: {
            NewCollectionView(showSheet: $showSheet)
        })
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
