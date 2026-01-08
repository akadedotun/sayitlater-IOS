//
//  AuthenticationService.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import LocalAuthentication

class AuthenticationService {
    static let shared = AuthenticationService()
    
    private let keychain = KeychainService.shared
    private let context = LAContext()
    
    private init() {}
    
    var isLockEnabled: Bool {
        get {
            keychain.getBool(forKey: "isLockEnabled") ?? false
        }
        set {
            keychain.setBool(newValue, forKey: "isLockEnabled")
        }
    }
    
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        guard isLockEnabled else {
            completion(true, nil)
            return
        }
        
        var error: NSError?
        let reason = "Unlock Say It Later"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success, authenticationError)
                }
            }
        } else {
            completion(false, error)
        }
    }
    
    func invalidate() {
        context.invalidate()
    }
}
