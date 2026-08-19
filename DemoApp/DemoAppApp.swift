//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Omkar Chougule on 03/05/26.
//

import SwiftUI

@main
struct DemoAppApp: App {
    init() {
        AnalyticsManager.shared.configure()
        AnalyticsManager.shared.track(.appLaunched)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
