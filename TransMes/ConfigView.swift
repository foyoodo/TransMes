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
            List {
                Section(header: Text("常规设置")) {
                    NavigationLink(destination: APIConfigView()) {
                        Label("API Key", systemImage: "mappin.circle.fill")
                    }
                    Picker(selection: $appearanceValue, label: Label("外观设置", systemImage: "paintpalette.fill"), content: {
                        Text("跟随系统").tag(0)
                        Text("浅色模式").tag(1)
                        Text("深色模式").tag(2)
                    })
                }
                Section(header: Text("帮助与反馈")) {
                    NavigationLink(destination: EmptyView()) {
                        Label("如何使用", systemImage: "questionmark.circle.fill")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Label("反馈问题", systemImage: "arrow.up.circle.fill")
                    }
                }
                Section(header: Text("其他")) {
                    NavigationLink(destination: EmptyView()) {
                        Label("评价应用", systemImage: "face.dashed.fill")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Label("分享给朋友", systemImage: "square.and.arrow.up.fill")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Label("关于小译", systemImage: "exclamationmark.circle.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("设置", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("完成")
            }))
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
