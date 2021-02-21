//
//  APIConfigView.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

struct APIConfigView: View {
    @AppStorage("CaiyunToken") private var CaiyunToken = ""
    @AppStorage("SogouPid") private var SogouPid = ""
    @AppStorage("SogouKey") private var SogouKey = ""

    var body: some View {
        Form {
            Section(header: Text("彩云小译")) {
                SecureField("Token", text: $CaiyunToken)
            }

            Section(header: Text("搜狗翻译")) {
                SecureField("Pid", text: $SogouPid)
                SecureField("Key", text: $SogouKey)
            }
        }
    }
}

struct APIConfigView_Previews: PreviewProvider {
    static var previews: some View {
        APIConfigView()
    }
}
