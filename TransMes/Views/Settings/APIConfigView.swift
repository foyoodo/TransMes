//
//  APIConfigView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct APIConfigView: View {
    @AppStorage("CaiyunToken") private var CaiyunToken = ""
    @AppStorage("MrTranslatorSecretID") private var MrTranslatorSecretID = ""
    @AppStorage("MrTranslatorSecretKey") private var MrTranslatorSecretKey = ""
    @AppStorage("SougouDeepPID") private var SougouDeepPID = ""
    @AppStorage("SougouDeepKey") private var SougouDeepKey = ""
    var body: some View {
        Form {
            Section(header: Text("彩云小译")) {
                SecureField("Token", text: $CaiyunToken)
            }
            Section(header: Text("腾讯翻译君")) {
                TextField("Secret ID", text: $MrTranslatorSecretID)
                SecureField("Secret Key", text: $MrTranslatorSecretKey)
            }
            Section(header: Text("搜狗翻译")) {
                TextField("PID", text: $SougouDeepPID)
                SecureField("Key", text: $SougouDeepKey)
            }
            Button("测试一下", action: {})
        }
    }
}

struct APIConfigView_Previews: PreviewProvider {
    static var previews: some View {
        APIConfigView()
    }
}
