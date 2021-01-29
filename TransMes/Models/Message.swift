//
//  Message.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/25.
//

import Foundation

struct Message: Codable {
    var id: TimeInterval
    var myMessage: Bool
    var time: String
    var text: String
}
