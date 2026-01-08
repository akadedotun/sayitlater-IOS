//
//  PostWritingActionsView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct PostWritingActionsView: View {
    var onKeepForLater: () -> Void
    var onLetGo: () -> Void
    var onClose: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Question
                Text("What do you want to do with it?")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                // Action buttons
                VStack(spacing: 16) {
                    // Keep for later button (primary action)
                    Button(action: {
                        onKeepForLater()
                        dismiss()
                    }) {
                        Text("Keep for later")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.892, green: 0.892, blue: 0.892))
                            .cornerRadius(24)
                    }
                    
                    // Let go button
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("Let go")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.appText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: "2C2C2E"))
                            .cornerRadius(24)
                    }
                    
                    // Close button (text only)
                    Button(action: {
                        onClose()
                        dismiss()
                    }) {
                        Text("Close")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.appText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .alert("Let go?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Let go", role: .destructive) {
                    onLetGo()
                    dismiss()
                }
            } message: {
                Text("This will permanently delete what you wrote. This cannot be undone.")
            }
        }
    }
}

#Preview {
    PostWritingActionsView(
        onKeepForLater: {},
        onLetGo: {},
        onClose: {}
    )
}
