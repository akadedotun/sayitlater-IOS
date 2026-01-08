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
    
    @State private var heavierImage: UIImage?
    @State private var theSameImage: UIImage?
    @State private var lighterImage: UIImage?
    
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
                        image: heavierImage,
                        isSelected: selectedFeeling == .heavier,
                        onTap: {
                            selectedFeeling = .heavier
                            onSelect(.heavier)
                        }
                    )
                    
                    FeelingOption(
                        title: "The Same",
                        image: theSameImage,
                        isSelected: selectedFeeling == .same,
                        onTap: {
                            selectedFeeling = .same
                            onSelect(.same)
                        }
                    )
                    
                    FeelingOption(
                        title: "Lighter",
                        image: lighterImage,
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
            .onAppear {
                loadImages()
            }
        }
    }
    
    private func loadImages() {
        // Load Heavier image
        loadImage(from: "https://res.cloudinary.com/dvsi1jmrp/image/upload/v1767802128/heavier_scq3az.png") { image in
            heavierImage = image
        }
        
        // Load The Same image
        loadImage(from: "https://res.cloudinary.com/dvsi1jmrp/image/upload/v1767802292/thesame_my7cyh.png") { image in
            theSameImage = image
        }
        
        // Load Lighter image
        loadImage(from: "https://res.cloudinary.com/dvsi1jmrp/image/upload/v1767802268/lighter_b8prwv.png") { image in
            lighterImage = image
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

struct FeelingOption: View {
    let title: String
    let image: UIImage?
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                } else {
                    Rectangle()
                        .fill(Color.appText.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
                
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
