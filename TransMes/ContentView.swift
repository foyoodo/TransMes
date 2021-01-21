//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct Message {
    var id: TimeInterval
    var time: String
    var message: String
}

struct ContentView: View {
    @State var input = ""
    @State var showConfigView = false
    @State var messages: Array<Message> = [
        Message(id: Date().timeIntervalSince1970, time: "2021-09-01 20:22:03", message: "NavigationLink should be inside NavigationView hierarchy. The Menu is outside navigation view, so put buttons inside menu which activate navigation link placed inside navigation view, eg. hidden in background.")
    ]
    var body: some View {
        TabView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(messages, id: \.id) { result in
                                VStack {
                                    Text(result.message)
                                        .font(Font.system(size: 16, weight: .regular, design: .default))
                                    Text("timeInterval: \(result.id)\n\(result.time)")
                                        .font(Font.system(size: 12, weight: .regular, design: .default))
                                        .foregroundColor(Color.blue)
                                        .shadow(radius: 3)
                                }
                                .mesStyle()
                            }
                            .onAppear {
                                value.scrollTo(messages.count - 1, anchor: .bottom)
                            }
                            .onChange(of: messages.count) { _ in
                                value.scrollTo(messages.count - 1, anchor: .bottom)
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
                            Button(action: {
                                self.messages.append(Message(id: Date().timeIntervalSince1970, time: currentTime(), message: input))
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
            .tabItem {
                Image(systemName: "note.text")
                Text("小译")
            }
            
            NavigationView {
                VStack {
                    Text("收藏")
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "sun.min.fill")
                            Text("收藏").font(.headline)
                        }
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    self.showConfigView.toggle()
                }) {
                    Image(systemName: "gear")
                })
                .sheet(isPresented: $showConfigView) {
                    ConfigView()
                }
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
