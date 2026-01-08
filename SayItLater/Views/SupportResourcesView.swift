//
//  SupportResourcesView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct SupportResourcesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Support Resources")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText)
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 24) {
                    SupportResourceCard(
                        title: "Samaritans",
                        number: "116 123",
                        description: "Call or text 24/7",
                        isEmergency: false
                    )
                    
                    SupportResourceCard(
                        title: "NHS 111",
                        number: "111",
                        description: "Non-emergency medical help",
                        isEmergency: false
                    )
                    
                    SupportResourceCard(
                        title: "Emergency Services",
                        number: "999",
                        description: "For immediate emergencies",
                        isEmergency: true
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.appBackground)
    }
}

struct SupportResourceCard: View {
    let title: String
    let number: String
    let description: String
    let isEmergency: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.appText)
                
                if isEmergency {
                    Spacer()
                    Text("EMERGENCY")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Button(action: {
                // For Samaritans, also support text (SMS)
                if title == "Samaritans" {
                    // Try SMS first, fallback to call
                    if let smsURL = URL(string: "sms:116123") {
                        UIApplication.shared.open(smsURL)
                    } else if let callURL = URL(string: "tel://116123") {
                        UIApplication.shared.open(callURL)
                    }
                } else {
                    // For others, just call
                    let cleanNumber = number.replacingOccurrences(of: " ", with: "")
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
            
            Text(description)
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
