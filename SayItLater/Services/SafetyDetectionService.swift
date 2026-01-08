//
//  SafetyDetectionService.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation

class SafetyDetectionService {
    // Simple keyword/phrase matching for on-device detection
    private let suicidalKeywords = [
        "kill myself", "end my life", "suicide", "take my life",
        "not want to live", "better off dead", "end it all"
    ]
    
    private let selfHarmKeywords = [
        "hurt myself", "self harm", "cut myself", "harm myself",
        "hurt myself", "self-injury"
    ]
    
    func detectSafetyIssues(in text: String) -> Bool {
        let lowercasedText = text.lowercased()
        
        // Check for suicidal ideation
        for keyword in suicidalKeywords {
            if lowercasedText.contains(keyword) {
                return true
            }
        }
        
        // Check for self-harm intent
        for keyword in selfHarmKeywords {
            if lowercasedText.contains(keyword) {
                return true
            }
        }
        
        return false
    }
}
