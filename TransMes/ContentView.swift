//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    @State var input = ""
    @State var showConfigView = false
    @State var messages: Array<String> = [
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view.",
        "Within the same ZStack, you will create another VStack which belongs to the second segment control view."
    ]
    var body: some View {
        TabView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { value in
                        LazyVStack {
                            ForEach(0..<messages.count) { index in
                                Text(messages[index])
                                    .mesStyle()
                                    .id(index)
                                    .contextMenu(menuItems: {
                                        Text("Menu Item 1")
                                        Text("Menu Item 2")
                                    })
                            }
                            .onAppear {
                                value.scrollTo(messages.count - 1, anchor: .bottom)
                            }
                            .onChange(of: messages.count) { _ in
                                value.scrollTo(messages.count - 1, anchor: .bottom)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
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
                                self.messages.append(input)
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
                .navigationBarTitle("收藏", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showConfigView.toggle()
                }) {
                    Image(systemName: "gear")
                })
            }
            .sheet(isPresented: $showConfigView) {
                ConfigView()
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
