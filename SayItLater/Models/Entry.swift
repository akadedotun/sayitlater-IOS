//
//  Entry.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import SwiftData

@Model
final class Entry {
    var id: UUID
    var text: String
    var date: Date
    var feeling: FeelingResult
    var safetyFlag: Bool
    
    init(text: String, date: Date = Date(), feeling: FeelingResult = .same, safetyFlag: Bool = false) {
        self.id = UUID()
        self.text = text
        self.date = date
        self.feeling = feeling
        self.safetyFlag = safetyFlag
    }
}

enum FeelingResult: String, Codable, CaseIterable {
    case lighter = "lighter"
    case same = "the same"
    case heavier = "heavier"
    
    var displayName: String {
        return self.rawValue
    }
}
