//
//  StringRelated.swift
//  TransMes
//
//  Created by foyoodo on 2021/2/20.
//

import CryptoKit

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
