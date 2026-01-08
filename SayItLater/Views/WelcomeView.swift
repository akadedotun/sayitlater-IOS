//
//  WelcomeView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var hasSeenWelcome: Bool
    @State private var splashImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 0) {
                // Tangled line drawing icon
                if let image = splashImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 163, height: 166)
                } else {
                    // Placeholder while loading
                    Rectangle()
                        .fill(Color.appText.opacity(0.1))
                        .frame(width: 163, height: 166)
                }
                
                // 24px spacing between image and content
                Spacer()
                    .frame(height: 24)
                
                // Title
                Text("Say It Later")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.appText)
                
                // 16px spacing between title and description
                Spacer()
                    .frame(height: 16)
                
                // Description
                Text("A private space to write what you're not ready to say out loud, then let it go.")
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(Color(red: 0.786, green: 0.766, blue: 0.766))
                    .multilineTextAlignment(.center)
                    .frame(width: 338, height: 50)
                    .kerning(-0.32)
                    .lineSpacing(16 * 0.31) // Line height multiple 1.31 (16pt * 0.31 = 4.96pt spacing)
                    .fixedSize(horizontal: false, vertical: true)
                
                // 24px spacing between description and privacy statement
                Spacer()
                    .frame(height: 24)
                
                // Privacy statement in a box
                Text("Nothing is shared. Everything stays on your device.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "2C2C2E"))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Start writing button
            Button(action: {
                hasSeenWelcome = true
            }) {
                Text("Start writing")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(Color(red: 0.892, green: 0.892, blue: 0.892))
                    .cornerRadius(24)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .onAppear {
            loadSplashImage()
        }
    }
    
    private func loadSplashImage() {
        guard let url = URL(string: "https://res.cloudinary.com/dvsi1jmrp/image/upload/v1767797856/sayitlater_ulqjtx.png") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.splashImage = image
            }
        }.resume()
    }
}

#Preview {
    WelcomeView(hasSeenWelcome: .constant(false))
}
