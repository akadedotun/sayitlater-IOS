//
//  FeelingSelectionView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct FeelingSelectionView: View {
    @Binding var selectedFeeling: FeelingResult?
    var onSelect: (FeelingResult) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Question
                Text("How did you feel after writing this?")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.appText)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                // Options
                VStack(spacing: 16) {
                    FeelingOption(
                        title: "Heavier",
                        imageName: "heavierIcon",
                        isSelected: selectedFeeling == .heavier,
                        onTap: {
                            selectedFeeling = .heavier
                            onSelect(.heavier)
                        }
                    )
                    
                    FeelingOption(
                        title: "The Same",
                        imageName: "theSameIcon",
                        isSelected: selectedFeeling == .same,
                        onTap: {
                            selectedFeeling = .same
                            onSelect(.same)
                        }
                    )
                    
                    FeelingOption(
                        title: "Lighter",
                        imageName: "lighterIcon",
                        isSelected: selectedFeeling == .lighter,
                        onTap: {
                            selectedFeeling = .lighter
                            onSelect(.lighter)
                        }
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
        }
    }
}

struct FeelingOption: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                
                // Text
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appText)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(hex: "2C2C2E"))
            .cornerRadius(12)
        }
    }
}

#Preview {
    FeelingSelectionView(selectedFeeling: .constant(nil), onSelect: { _ in })
}
