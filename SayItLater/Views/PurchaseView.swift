//
//  PurchaseView.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager.shared
    @State private var isPurchasing = false
    @State private var purchaseError: String?
    @State private var showRestoreAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        Text("Unlock Premium")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 40)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(
                            icon: "faceid",
                            title: "Face ID / Passcode Lock",
                            description: "Protect your entries with biometric authentication"
                        )
                        
                        FeatureRow(
                            icon: "square.and.arrow.up",
                            title: "Export Entries",
                            description: "Export your entries as a text file"
                        )
                        
                        FeatureRow(
                            icon: "chart.bar",
                            title: "Reflection View",
                            description: "Simple insights about your entries"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Price
                    if let product = purchaseManager.products.first(where: { $0.id == purchaseManager.productID }) {
                        VStack(spacing: 8) {
                            Text(product.displayPrice)
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(.primary)
                            Text("One-time purchase")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 20)
                    }
                    
                    // Purchase button
                    Button(action: {
                        purchase()
                    }) {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Purchase Premium")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isPurchasing ? Color.gray : Color.accentColor)
                        .cornerRadius(12)
                    }
                    .disabled(isPurchasing)
                    .padding(.horizontal, 40)
                    
                    if let error = purchaseError {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    // Restore purchases
                    Button(action: {
                        restorePurchases()
                    }) {
                        Text("Restore Purchases")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Purchases Restored", isPresented: $showRestoreAlert) {
                Button("OK") {
                    if purchaseManager.hasPurchased {
                        dismiss()
                    }
                }
            } message: {
                Text(purchaseManager.hasPurchased ? "Your purchase has been restored." : "No previous purchases found.")
            }
            .task {
                await purchaseManager.loadProducts()
            }
        }
    }
    
    private func purchase() {
        isPurchasing = true
        purchaseError = nil
        
        Task {
            do {
                let success = try await purchaseManager.purchase()
                isPurchasing = false
                
                if success {
                    dismiss()
                }
            } catch {
                isPurchasing = false
                purchaseError = error.localizedDescription
            }
        }
    }
    
    private func restorePurchases() {
        Task {
            do {
                try await purchaseManager.restorePurchases()
                showRestoreAlert = true
            } catch {
                purchaseError = "Failed to restore purchases: \(error.localizedDescription)"
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PurchaseView()
}
