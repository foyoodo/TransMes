//
//  TransView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/22.
//

import SwiftUI

struct Message {
    var id: TimeInterval
    var time: String
    var message: String
    var result: String
}

struct TransView: View {
    @State var input = ""
    @State var messages: Array<Message> = [
        Message(id: Date().timeIntervalSince1970, time: "2021-01-19 21:01:19", message: "NavigationLink should be inside NavigationView hierarchy. The Menu is outside navigation view, so put buttons inside menu which activate navigation link placed inside navigation view, eg. hidden in background.", result: "NavigationLink 应该位于 NavigationView 层次结构中。菜单是外部导航视图，所以将按钮放在菜单内，激活导航链接放在导航视图内，比如隐藏在背景中。")
    ]
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                ScrollViewReader { value in
                    LazyVStack {
                        ForEach(messages, id: \.id) { result in
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
                                    var message = messages[0]
                                    message.id = Date().timeIntervalSince1970
                                    messages.append(message)
                                }) {
                                    Label("收藏", systemImage: "star")
                                }
                                Button(action: {
                                    
                                }) {
                                    Label("删除", systemImage: "trash")
                                }
                            }))
                        }
                        .onChange(of: messages.count) { _ in
                            value.scrollTo(messages[messages.count - 1].id, anchor: .bottom)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            ZStack(alignment: .bottom) {
                Capsule().fill(Color("BlankDetailColor"))
                HStack {
                    TextField("在这里输入文本", text: $input)
                        .autocapitalization(.sentences)
                        .background(Color("BlankDetailColor"))
                    ZStack {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .shadow(radius: 3)
                        Button(action: {
                            if (input != "") {
                                self.messages.append(Message(id: Date().timeIntervalSince1970, time: currentTime(), message: input, result: "这是一条测试使用的翻译结果，会在按下按钮的时候添加进来"))
                                input = ""
                            }
                        }, label: {
                            Image(systemName: "arrow.up")
                        })
                        .foregroundColor(Color.white)
                    }
                }
                .padding(.bottom, 5)
                .padding(.trailing, 5)
                .padding(.leading, 20)
            }
            .padding(10)
            .frame(height: 60)
        }
    }
}

struct TransView_Previews: PreviewProvider {
    static var previews: some View {
        TransView()
    }
}
