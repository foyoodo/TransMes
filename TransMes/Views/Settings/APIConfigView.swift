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
        }
    }
}

struct APIConfigView_Previews: PreviewProvider {
    static var previews: some View {
        APIConfigView()
    }
}
