//
//  PurchaseManager.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import StoreKit

@Observable
class PurchaseManager {
    static let shared = PurchaseManager()
    
    let productID = "com.sayitlater.premium"
    private let keychain = KeychainService.shared
    
    var hasPurchased: Bool {
        get {
            keychain.getBool(forKey: "hasPurchased") ?? false
        }
        set {
            keychain.setBool(newValue, forKey: "hasPurchased")
        }
    }
    
    var products: [Product] = []
    
    private init() {
        Task {
            await loadProducts()
        }
    }
    
    @MainActor
    func loadProducts() async {
        do {
            products = try await Product.products(for: [productID])
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    @MainActor
    func purchase() async throws -> Bool {
        guard let product = products.first(where: { $0.id == productID }) else {
            throw PurchaseError.productNotFound
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                hasPurchased = true
                return true
            case .unverified:
                throw PurchaseError.unverified
            }
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }
    
    @MainActor
    func restorePurchases() async throws {
        try await AppStore.sync()
        
        // Check if user has already purchased
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    hasPurchased = true
                    await transaction.finish()
                }
            }
        }
    }
}

enum PurchaseError: Error {
    case productNotFound
    case unverified
}
