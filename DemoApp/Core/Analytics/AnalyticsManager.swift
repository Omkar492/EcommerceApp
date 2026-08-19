//
//  AnalyticsManager.swift
//  DemoApp
//
//  Created by Omkar Chougule on 11/05/26.
//

import Foundation
// import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() { }
    
    func configure() {
        // FirebaseApp.configure()
        print("[Analytics] configured")
    }
    
    func track(_ event: AnalyticsEvent, parameters: [String: Any] = [:]) {
        print("[Analytics] event=\(event.rawValue), parameters=\(parameters)")
        
        // Analytics.logEvent(event.rawValue, parameters: parameters)
    }
    
    func trackScreen(_ name: String) {
        track(.screenViewed, parameters: ["screen_name": name])
        
        // Analytics.logEvent(AnalyticsEventScreenView, parameters: [
        //     AnalyticsParameterScreenName: name
        // ])
    }
}
