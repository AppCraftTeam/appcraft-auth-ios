//
//  ACFIRAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// Firebase authorization provider object, is a wrapper over third-party authorization services.
open class ACFIRAuthProvider {
        
    private let auth = Auth.auth()
    
    var outputQueue: DispatchQueue = .main
    
    /// Sign in method.
    /// - Parameters:
    ///   - credential: Represents a credential. See more in [offical site](https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/AuthCredential).
    ///   - handler: A callback block ``FIRAuthCallback``.
    open func signIn(with credential: AuthCredential, handler: @escaping ACFIRAuthCallback) {
        self.auth.signIn(with: credential, completion: { (data, error) in
            if let data = data {
                self.outputQueue.invoke(handler, with: .success(data))
            } else {
                self.outputQueue.invoke(
                    handler,
                    with: .failure(.firebaseAuthenticationError(reason: .signInError(error: error)))
                )
            }
        })
    }

    open func link(with credential: AuthCredential, handler: ((AuthDataResult?, Error?) -> Void)?) {
        self.auth.link(with: credential, outputQueue: outputQueue, completion: handler)
    }
    
    open func unlink(fromProvider provider: String, completion: ((User?, Error?) -> Void)? = nil) {
        self.auth.unlink(fromProvider: provider, outputQueue: outputQueue, completion: completion)
    }
    
    /// Description
    open func signOut() throws {
        try auth.signOut()
    }
}
