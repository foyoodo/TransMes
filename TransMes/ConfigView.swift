//
//  ConfigView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct ConfigView: View {
    @State var appearanceValue = 0
    @Environment(\.presentationMode) var mode
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    Text("常规设置")
                        .font(.footnote)
                        .offset(x: 12)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 0) {
                        NavigationLink(destination: APIConfigView()) {
                            ListCell(image: Image("api"), title: "API Key") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                        Divider().padding(.leading, 16)
                        NavigationLink(destination: EmptyView()) {
                            ListCell(image: Image("platte"), title: "外观设置") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    
                    Spacer().frame(height: 16)
                    
                    Text("帮助与反馈")
                        .font(.footnote)
                        .offset(x: 12)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 0) {
                        NavigationLink(destination: EmptyView()) {
                            ListCell(image: Image("help"), title: "如何使用") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                        Divider().padding(.leading, 16)
                        Button {
                            
                        } label: {
                            ListCell(image: Image("bug"), title: "反馈问题") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                    
                    Spacer().frame(height: 16)
                    
                    Text("其他")
                        .font(.footnote)
                        .offset(x: 12)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 0) {
                        Button {
                            
                        } label: {
                            ListCell(image: Image("star"), title: "评价应用") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                        Divider().padding(.leading, 16)
                        Button {
                            
                        } label: {
                            ListCell(image: Image("share-one"), title: "分享给朋友") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                        Divider().padding(.leading, 16)
                        NavigationLink(destination: EmptyView()) {
                            ListCell(image: Image("info"), title: "关于小译") {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                    .background(Color(.secondarySystemGroupedBackground).cornerRadius(12))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("设置", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
