//
//  CollectionView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct CollectionView: View {
    @State var showConfigView = false
    @State var collections: Array<Message> = [
        Message(id: Date().timeIntervalSince1970, time: "2021-01-19 21:01:19", message: "NavigationLink should be inside NavigationView hierarchy. The Menu is outside navigation view, so put buttons inside menu which activate navigation link placed inside navigation view, eg. hidden in background.", result: "NavigationLink 应该位于 NavigationView 层次结构中。菜单是外部导航视图，所以将按钮放在菜单内，激活导航链接放在导航视图内，比如隐藏在背景中。")
    ]
    var body: some View {
        VStack(spacing: 0, content: {
            ZStack {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(collections, id: \.id) { result in
                                VStack {
                                    Text(result.message)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .allowsTightening(true)
                                        .minimumScaleFactor(0.5)
                                    Divider()
                                    Text(result.result)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                    HStack {
                                        Spacer()
                                        Text("\(result.time)")
                                            .font(.system(size: 12, weight: .regular, design: .default))
                                            .foregroundColor(Color.blue)
                                            .shadow(radius: 3)
                                    }
                                }
                                .mesStyle()
                                .onTapGesture {
                                    
                                }
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(action: {
                                        
                                    }) {
                                        Label("删除", systemImage: "trash")
                                    }
                                }))
                            }
                            .onChange(of: collections.count) { _ in
                                value.scrollTo(collections[collections.count - 1].id, anchor: .bottom)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                HStack(content: {
                    Spacer()
                    Button(action: {
                        showConfigView.toggle()
                    }, label: {
                        Image(systemName: "gear")
                    })
                    .shadow(radius: 3)
                    .sheet(isPresented: $showConfigView, content: {
                        ConfigView()
                    })
                })
                .padding()
            }
        })
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
