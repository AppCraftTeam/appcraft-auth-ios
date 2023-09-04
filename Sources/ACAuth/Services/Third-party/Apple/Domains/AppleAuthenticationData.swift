//
//  AppleAuthenticationData.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import AuthenticationServices

/// Customized credential that results from a successful `Apple ID` authentication.
@available(iOS 13.0, *)
public struct AppleAuthenticationData {
    
    /// String representable JSON Web Token (JWT).
    public let token: String
    /// Unique random string.
    public let nonce: String
    /// Original representable JSON Web Token (JWT).
    public let identityToken: Data
    /// The separate parts of a person's name, allowing locale-aware formatting.
    public let persone: PersonNameComponents?

    init(credential: ASAuthorizationAppleIDCredential, nonce: String) throws {
        guard let identityToken = credential.identityToken,
              let token = String(data: identityToken, encoding: .utf8)
        else {
            throw ACAuthError.appleAuthenticationError(reason: .nilWhileUnwrappingAuthorizationToken)
        }
        self.token = token
        self.nonce = nonce
        self.persone = credential.fullName
        self.identityToken = identityToken
    }
}
