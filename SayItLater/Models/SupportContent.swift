//
//  SupportContent.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation

struct SupportResource {
    let title: String
    let number: String?
    let description: String
    let isEmergency: Bool
    let supportsSMS: Bool
}

struct SupportContent {
    let resources: [SupportResource]
    let fallbackMessage: String?
    let fallbackLink: String?
    let fallbackLinkText: String?
    
    static func content(for region: SupportRegion) -> SupportContent {
        switch region {
        case .uk:
            return SupportContent(
                resources: [
                    SupportResource(
                        title: "Samaritans",
                        number: "116 123",
                        description: "Call or text 24/7",
                        isEmergency: false,
                        supportsSMS: true
                    ),
                    SupportResource(
                        title: "NHS 111",
                        number: "111",
                        description: "Non-emergency medical help",
                        isEmergency: false,
                        supportsSMS: false
                    ),
                    SupportResource(
                        title: "Emergency Services",
                        number: "999",
                        description: "For immediate emergencies",
                        isEmergency: true,
                        supportsSMS: false
                    )
                ],
                fallbackMessage: nil,
                fallbackLink: nil,
                fallbackLinkText: nil
            )
            
        case .us:
            return SupportContent(
                resources: [
                    SupportResource(
                        title: "988 Suicide & Crisis Lifeline",
                        number: "988",
                        description: "Call or text 24/7",
                        isEmergency: false,
                        supportsSMS: true
                    ),
                    SupportResource(
                        title: "Emergency Services",
                        number: "911",
                        description: "For immediate emergencies",
                        isEmergency: true,
                        supportsSMS: false
                    )
                ],
                fallbackMessage: nil,
                fallbackLink: nil,
                fallbackLinkText: nil
            )
            
        case .france:
            return SupportContent(
                resources: [
                    SupportResource(
                        title: "SOS Suicide",
                        number: "3114",
                        description: "24/7 support",
                        isEmergency: false,
                        supportsSMS: false
                    ),
                    SupportResource(
                        title: "Emergency Services",
                        number: "112",
                        description: "For immediate emergencies",
                        isEmergency: true,
                        supportsSMS: false
                    )
                ],
                fallbackMessage: nil,
                fallbackLink: nil,
                fallbackLinkText: nil
            )
            
        case .other:
            return SupportContent(
                resources: [
                    SupportResource(
                        title: "Emergency Services",
                        number: nil,
                        description: "Contact your local emergency number",
                        isEmergency: true,
                        supportsSMS: false
                    )
                ],
                fallbackMessage: "If you're in immediate danger, contact your local emergency number.",
                fallbackLink: "https://findahelpline.com",
                fallbackLinkText: "You can find local support here: findahelpline.com"
            )
        }
    }
}
