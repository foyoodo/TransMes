//
//  TransMesApp.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

@main
struct TransMesApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
