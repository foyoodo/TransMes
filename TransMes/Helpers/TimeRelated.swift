//
//  TimeRelated.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/21.
//

import Foundation

func currentTime() -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return dateformatter.string(from: Date())
}
