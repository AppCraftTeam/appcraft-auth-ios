//
//  FIRTwitterAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// A provider object that represents `Firebase` authentication with `Twitter`.
open class FIRTwitterAuthProvider: FIRAuthProvider, FIRAuthPerformer {
    open func logIn(handler: @escaping FIRAuthCallback) {
        OAuthProvider(providerID: "twitter.com").getCredentialWith(nil) { (credential, error) in
            guard let credential = credential else {
                self.outputQueue.invoke(
                    handler,
                    with: .failure(
                        .firebaseAuthenticationError(reason: .nilWhileUnwrappingCredential(error: error))
                    )
                )
                return
            }
            self.signIn(with: credential, handler: handler)
        }
    }
}

// MARK: - Fabrication
public extension FIRAuthPerformer where Self == FIRTwitterAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Twitter`.
    /// - Returns: Twitter authorization performer.
    static func twitter() -> FIRTwitterAuthProvider where Self: FIRTwitterAuthProvider {
        FIRTwitterAuthProvider()
    }
}
