//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    @State var input = ""
    @State var showPerference = false
    var body: some View {
        TabView {
            VStack {
                List {
                    Text("第一项")
                    Text("第二项")
                }
                
                ZStack(alignment: .bottom) {
                    Capsule().fill(Color("BlankDetailColor"))
                    HStack {
                        TextField("在这里输入文本", text: $input)
                            .background(Color("BlankDetailColor"))
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Button(action: {}, label: {
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
                .background(Color(UIColor.systemGroupedBackground))
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
                    self.showPerference.toggle()
                }) {
                    Image(systemName: "gear")
                }.sheet(isPresented: $showPerference) {
                    ConfigView()
                })
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
