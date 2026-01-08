//
//  RegionDetectionService.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation

enum SupportRegion {
    case uk
    case us
    case france
    case other
}

struct RegionDetectionService {
    static func detectRegion() -> SupportRegion {
        guard let regionCode = Locale.current.regionCode else {
            return .other
        }
        
        switch regionCode {
        case "GB":
            return .uk
        case "US":
            return .us
        case "FR":
            return .france
        default:
            return .other
        }
    }
}
