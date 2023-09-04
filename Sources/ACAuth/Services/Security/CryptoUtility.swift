//
//  CryptoUtility.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import CryptoKit
import CommonCrypto
import Foundation

/// Information security utilities
enum CryptoUtility {
    
    /// Generate a unique random string `nonce` — which you will use to make sure the ID token
    /// you get was granted specifically in response to your app's authentication request.
    ///
    /// - Author: https://firebase.google.com/docs/auth/ios/facebook-login#implement_facebook_limited_login
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    /// Hashing algorithm SHA-256.
    static func sha256(_ input: String) -> String {
        if #available(iOS 13, *) {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            return hashString
        } else {
            guard let data = input.data(using: .utf8) else {
                return ""
            }
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
            }
            return Data(hash).base64EncodedString(options: [])
        }
    }
}
