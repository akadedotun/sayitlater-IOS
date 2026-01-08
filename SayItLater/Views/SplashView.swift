//
//  SplashView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var splashImage: UIImage?
    
    var body: some View {
        VStack {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .onAppear {
            loadSplashImage()
            
            // Auto-advance after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showSplash = false
                }
            }
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
    SplashView(showSplash: .constant(true))
}
