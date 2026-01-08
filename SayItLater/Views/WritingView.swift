//
//  WritingView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct WritingView: View {
    @Binding var draft: String
    @FocusState private var isFocused: Bool
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // 16px spacing at top
            Spacer()
                .frame(height: 16)
            
            // Prompt text
            Text("What do you need to say right now?")
                .font(.system(size: 24, weight: .semibold, design: .default))
                .foregroundColor(Color(red: 0.892, green: 0.892, blue: 0.892))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .kerning(-0.32)
                .lineSpacing(24 * 0.01) // Line height multiple 1.01 (24pt * 0.01 = 0.24pt spacing)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: false)
            
            // 16px spacing below prompt
            Spacer()
                .frame(height: 16)
            
            // Large text input (paste disabled)
            ZStack(alignment: .topLeading) {
                if draft.isEmpty {
                    Text("What's bothering you...")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.appSecondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .allowsHitTesting(false)
                }
                NoPasteTextEditorV2(text: $draft, isFocused: $isFocused)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "2C2C2E"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            // 24px spacing above button
            Spacer()
                .frame(height: 24)
            
            // Submit button
            Button(action: onDone) {
                Text("Submit")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.appSecondary : Color.appBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.5) : Color(red: 0.892, green: 0.892, blue: 0.892))
                    .cornerRadius(24)
            }
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.appBackground)
        .onAppear {
            // Keyboard open immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }
}

#Preview {
    WritingView(draft: .constant(""), onDone: {})
}
