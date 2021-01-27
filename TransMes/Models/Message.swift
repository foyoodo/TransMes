//
//  Message.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/25.
//

import Foundation

struct Message: Codable {
    var id: TimeInterval
    var time: String
    var message: String
    var result: String
}
