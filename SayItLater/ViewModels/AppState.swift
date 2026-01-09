//
//  AppState.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import SwiftUI

@Observable
class AppState {
    var hasSeenWelcome: Bool {
        didSet {
            // Capture the value explicitly to avoid closure capture issues
            let value = hasSeenWelcome
            // Use async to avoid blocking
            DispatchQueue.global(qos: .utility).async {
                UserDefaults.standard.set(value, forKey: "hasSeenWelcome")
            }
        }
    }
    
    var showSplash: Bool = true
    var currentDraft: String = ""
    var showFeelingSelection: Bool = false
    var showPostWritingActions: Bool = false
    var selectedFeeling: FeelingResult?
    var detectedSafetyIssue: Bool = false
    var showSafetySupport: Bool = false
    
    init() {
        // Load UserDefaults - this is fast and needed for routing
        // We'll always show splash first, then route based on this
        self.hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    }
    
    func resetWritingFlow() {
        currentDraft = ""
        showFeelingSelection = false
        showPostWritingActions = false
        selectedFeeling = nil
        detectedSafetyIssue = false
        showSafetySupport = false
    }
}
