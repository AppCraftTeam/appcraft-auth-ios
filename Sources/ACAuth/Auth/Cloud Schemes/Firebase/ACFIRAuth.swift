//
//  ACFIRAuth.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Firebase
import FirebaseAuth

/// An object that provides a simple interface for performing authorization on a firebase service.
///
///
/// For authorization, create a ``ACFIRAuth`` object and use one of the providers in its initializer ``init(provider:)``.
///
/// **Example apple auth:**
/// ```swift
///     // Create firebase auth service
///     let appleAuth = ACFIRAuth(provider: .apple(scopes: [.email]))
///
///     // Сall the login method
///     auth.logIn(handler: { result in
///         // Process the result
///     })
/// ```
open class ACFIRAuth: ACFIRAuthPerformer {
    
    private var provider: ACFIRAuthPerformer
    
    /// Creates ACFIRAuth instance with selected provider.
    /// - Parameter provider: Third-party auth service.
    public init(provider: ACFIRAuthPerformer) {
        self.provider = provider
    }
    
    /// Login method with the previously specified provider.
    /// - Parameter handler: A callback block ``ACFIRAuthCallback``.
    open func logIn(handler: @escaping ACFIRAuthCallback) {
        self.provider.logIn(handler: handler)
    }
    
    /// Login method with the specified provider.
    /// - Parameters:
    ///   - provider: Third-party auth service.
    ///   - handler: A callback block ``ACFIRAuthCallback``.
    open func logIn(provider: ACFIRAuthPerformer, handler: @escaping ACFIRAuthCallback) {
        self.provider = provider
        self.logIn(handler: handler)
    }
    
    public static func configure() {
        FirebaseApp.configure()
    }
}
