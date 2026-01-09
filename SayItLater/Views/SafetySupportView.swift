//
//  SafetySupportView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct SafetySupportView: View {
    var onGetSupport: () -> Void
    var onNotRightNow: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Illustration
            Image("heavyIllustration")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 186, height: 186)
            
            VStack(spacing: 16) {
                Text("What you wrote sounds really heavy")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                
                Text("You don't have to deal with this alone")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 338, height: 103)
            .offset(x: -0.5) // CenterX offset of -0.5
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: onGetSupport) {
                    Text("Get support now")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.appBackground)
                        .frame(width: 362, height: 45)
                        .background(Color(red: 0.892, green: 0.892, blue: 0.892))
                        .cornerRadius(24)
                }
                
                Button(action: onNotRightNow) {
                    Text("Not right now")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.appText)
                        .frame(width: 362, height: 45)
                        .background(Color(red: 0.169, green: 0.169, blue: 0.173))
                        .cornerRadius(24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

#Preview {
    SafetySupportView(
        onGetSupport: {},
        onNotRightNow: {}
    )
}
