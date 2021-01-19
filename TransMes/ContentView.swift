//
//  ContentView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ContentView: View {
    @State var input = ""
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Spacer()
                    HStack {
                        ZStack {
                            Capsule()
                                .fill(Color("BlankDetailColor"))
                                .frame(minHeight: 34, alignment: .bottom)
                            HStack {
                                TextField("在这里输入文本", text: $input)
                                    .background(Color("BlankDetailColor"))
                                    .onAppear { self.input = "" }
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
                            .padding(.trailing, 5)
                            .padding(.leading, 17)
                        }
                    }
                    .padding(10)
                    .frame(height: 60)
                    .border(Color("BlankDetailColor"))
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
