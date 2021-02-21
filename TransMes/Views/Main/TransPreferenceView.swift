//
//  TransPreferenceView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/25.
//

import SwiftUI

let Language = [
    "auto" : "自动检测",
    "zh" : "中文简体",
    "en" : "英语",
    "ja" : "日语"
]

let LanguageCode = [
    "auto",
    "zh",
    "en",
    "ja"
]

struct TransPreferenceView: View {
    @AppStorage("transService") private var transService = 0
    @AppStorage("sourceLanguageCode") private var sourceLanguageCode = "auto"
    @AppStorage("targetLanguageCode") private var targetLanguageCode = "zh"

    @Binding var showSheet: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("翻译服务")) {
                    Toggle(isOn: .constant(false)) {
                        Text("启用词典")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color("AccentColor")))

                    Picker(selection: $transService, label: Text("翻译服务")) {
                        Text("彩云小译").tag(0)
                        Text("搜狗翻译").tag(1)
                    }
                }

                Section(header: Text("翻译语言")) {
                    Picker(selection: $sourceLanguageCode, label: Text("源语言")) {
                        ForEach(0..<LanguageCode.count) { index in
                            Text(Language[LanguageCode[index]]!).tag(LanguageCode[index])
                        }
                    }

                    Picker(selection: $targetLanguageCode, label: Text("目标语言")) {
                        ForEach(1..<LanguageCode.count) { index in
                            Text(Language[LanguageCode[index]]!).tag(LanguageCode[index])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("翻译偏好"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Text("完成")
                    })
            )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TransPreferenceView_Preview: PreviewProvider {
    static var previews: some View {
        TransPreferenceView(showSheet: .constant(true))
    }
}
