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
    
    @State private var heavyImage: UIImage?
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Illustration
            if let image = heavyImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 186, height: 186)
            } else {
                Rectangle()
                    .fill(Color.appText.opacity(0.1))
                    .frame(width: 372, height: 372)
                    .cornerRadius(12)
            }
            
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
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let urlString = "https://res.cloudinary.com/dvsi1jmrp/image/upload/v1767864595/heavy_un5h3w.png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                heavyImage = image
            }
        }.resume()
    }
}

#Preview {
    SafetySupportView(
        onGetSupport: {},
        onNotRightNow: {}
    )
}
