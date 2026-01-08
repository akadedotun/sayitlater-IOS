//
//  LockView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct LockView: View {
    @State private var isAuthenticating = false
    @State private var authenticationError: String?
    var onUnlock: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.appSecondary)
            
            Text("Say It Later")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.appText)
            
            if let error = authenticationError {
                Text(error)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if isAuthenticating {
                ProgressView()
                    .tint(.appText)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .onAppear {
            authenticate()
        }
    }
    
    private func authenticate() {
        isAuthenticating = true
        authenticationError = nil
        
        AuthenticationService.shared.authenticate { success, error in
            isAuthenticating = false
            
            if success {
                onUnlock()
            } else {
                authenticationError = error?.localizedDescription ?? "Authentication failed"
            }
        }
    }
}

#Preview {
    LockView(onUnlock: {})
}
