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
            UserDefaults.standard.set(hasSeenWelcome, forKey: "hasSeenWelcome")
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
