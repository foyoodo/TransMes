//
//  TransMesApp.swift
//  TransMes
//
//  Created by foyoodo on 2021/1/19.
//

import SwiftUI

@main
struct TransMesApp: App {
    @StateObject var dataModel = DataModel()

    @Environment(\.scenePhase) private var scenePhase

    @AppStorage("systemAppearance") private var systemAppearance = true
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView(dataModel: dataModel)
                .preferredColorScheme(systemAppearance ? nil : (isDarkMode ? .dark : .light))
        }
        .onChange(of: scenePhase) { scenePhase in
            if scenePhase == .inactive {
                dataModel.saveMessages()
                dataModel.saveCollections()
            }
        }
    }
}
