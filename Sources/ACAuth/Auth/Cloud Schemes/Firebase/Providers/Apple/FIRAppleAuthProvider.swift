//
//  FIRAppleAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth
import AuthenticationServices

/// A provider object that represents `Firebase` authentication with a `Apple`.
open class FIRAppleAuthProvider: FIRAuthProvider, FIRAuthPerformer {
    
    // MARK: Properties
    private let appleAuthenticationService: AppleAuthServiceInterface
    
    // MARK: - Initialization
    /// Creates `FIRAppleAuthProvider` instance with custom auth service.
    /// - Parameters:
    ///   - service: Apple authorization service. See more ``AppleAuthServiceInterface``.
    public init(service: AppleAuthServiceInterface) {
        self.appleAuthenticationService = service
    }
    
    /// Creates `FIRAppleAuthProvider` instance.
    /// - Parameters:
    ///   - scopes: The kinds of contact information that can be requested from the user.
    public convenience init(scopes: [ASAuthorization.Scope]) {
        self.init(service: AppleAuthService(scopes: scopes))
    }
    
    // MARK: - Perform auth
    open func logIn(handler: @escaping FIRAuthCallback) {
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
public extension FIRAuthPerformer where Self == FIRAppleAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Apple`.
    /// - Parameters:
    ///   - scopes: The kinds of contact information that can be requested from the user.
    /// - Returns: Apple authorization performer.
    static func apple(scopes: [ASAuthorization.Scope] = [.fullName, .email]) -> FIRAuthPerformer {
        FIRAppleAuthProvider(scopes: scopes)
    }
}