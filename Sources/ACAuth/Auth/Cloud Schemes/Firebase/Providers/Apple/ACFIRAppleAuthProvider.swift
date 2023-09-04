//
//  ACFIRAppleAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth
import AuthenticationServices

/// A provider object that represents `Firebase` authentication with a `Apple`.
open class ACFIRAppleAuthProvider: ACFIRAuthProvider, ACFIRAuthPerformer {
    
    // MARK: Properties
    private let appleAuthenticationService: ACAppleAuthServiceInterface
    
    // MARK: - Initialization
    /// Creates `ACFIRAppleAuthProvider` instance with custom auth service.
    /// - Parameters:
    ///   - service: Apple authorization service. See more ``ACAppleAuthServiceInterface``.
    public init(service: ACAppleAuthServiceInterface) {
        self.appleAuthenticationService = service
    }
    
    /// Creates `ACFIRAppleAuthProvider` instance.
    /// - Parameters:
    ///   - scopes: The kinds of contact information that can be requested from the user.
    public convenience init(scopes: [ASAuthorization.Scope]) {
        self.init(service: ACAppleAuthService(scopes: scopes))
    }
    
    // MARK: - Perform auth
    open func logIn(handler: @escaping ACFIRAuthCallback) {
        self.appleAuthenticationService.logIn(handler: { (result) in
            switch result {
            case let .success(data):
                if !data.nonce.isEmpty {
                    let credential = OAuthProvider.credential(
                        withProviderID: "apple.com",
                        idToken: data.token,
                        rawNonce: data.nonce
                    )
                    self.signIn(with: credential, handler: handler)
                } else {
                    self.outputQueue.invoke(handler, with: .failure(.appleAuthenticationError(reason: .invalidNonce)))
                }
            case let .failure(error):
                self.outputQueue.invoke(handler, with: .failure(.appleAuthenticationError(reason: error)))
            }
        })
    }
}

// MARK: - Fabrication
public extension ACFIRAuthPerformer where Self == ACFIRAppleAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Apple`.
    /// - Parameters:
    ///   - scopes: The kinds of contact information that can be requested from the user.
    /// - Returns: Apple authorization performer.
    static func apple(scopes: [ASAuthorization.Scope] = [.fullName, .email]) -> ACFIRAuthPerformer {
        ACFIRAppleAuthProvider(scopes: scopes)
    }
}
