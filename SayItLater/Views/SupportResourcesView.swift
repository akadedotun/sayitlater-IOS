//
//  SupportResourcesView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct SupportResourcesView: View {
    @State private var supportContent: SupportContent
    
    init() {
        let region = RegionDetectionService.detectRegion()
        _supportContent = State(initialValue: SupportContent.content(for: region))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Support Resources")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText)
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(Array(supportContent.resources.enumerated()), id: \.offset) { _, resource in
                        SupportResourceCard(
                            resource: resource
                        )
                    }
                    
                    // Fallback message for Other region
                    if let message = supportContent.fallbackMessage {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(message)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.appText)
                                .multilineTextAlignment(.leading)
                            
                            if let link = supportContent.fallbackLink,
                               let linkText = supportContent.fallbackLinkText {
                                Link(linkText, destination: URL(string: link)!)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.appAccent)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(Color(hex: "2C2C2E"))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground)
    }
}

struct SupportResourceCard: View {
    let resource: SupportResource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(resource.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.appText)
                
                if resource.isEmergency {
                    Spacer()
                    Text("EMERGENCY")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.appSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "2C2C2E"))
                        .cornerRadius(4)
                }
            }
            
            if let number = resource.number {
                Button(action: {
                    let cleanNumber = number.replacingOccurrences(of: " ", with: "")
                    
                    if resource.supportsSMS {
                        // Try SMS first, fallback to call
                        if let smsURL = URL(string: "sms:\(cleanNumber)") {
                            UIApplication.shared.open(smsURL)
                        } else if let callURL = URL(string: "tel://\(cleanNumber)") {
                            UIApplication.shared.open(callURL)
                        }
                    } else {
                        // Just call
                        if let url = URL(string: "tel://\(cleanNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }
                }) {
                    HStack {
                        Text(number)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.appAccent)
                        Image(systemName: "phone.fill")
                            .foregroundColor(.appAccent)
                    }
                }
            }
            
            Text(resource.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.appSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(hex: "2C2C2E"))
        .cornerRadius(12)
    }
}

#Preview {
    SupportResourcesView()
}
