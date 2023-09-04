//
//  FIRAuth.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Firebase
import FirebaseAuth

/// An object that provides a simple interface for performing authorization on a firebase service.
///
///
/// For authorization, create a ``FIRAuth`` object and use one of the providers in its initializer ``init(provider:)``.
///
/// **Example apple auth:**
/// ```swift
///     // Create firebase auth service
///     let appleAuth = FIRAuth(provider: .apple(scopes: [.email]))
///
///     // Сall the login method
///     auth.logIn(handler: { result in
///         // Process the result
///     })
/// ```
open class FIRAuth: FIRAuthPerformer {
    
    private var provider: FIRAuthPerformer
    
    /// Creates FIRAuth instance with selected provider.
    /// - Parameter provider: Third-party auth service.
    public init(provider: FIRAuthPerformer) {
        self.provider = provider
    }
    
    /// Login method with the previously specified provider.
    /// - Parameter handler: A callback block ``FIRAuthCallback``.
    open func logIn(handler: @escaping FIRAuthCallback) {
        self.provider.logIn(handler: handler)
    }
    
    /// Login method with the specified provider.
    /// - Parameters:
    ///   - provider: Third-party auth service.
    ///   - handler: A callback block ``FIRAuthCallback``.
    open func logIn(provider: FIRAuthPerformer, handler: @escaping FIRAuthCallback) {
        self.provider = provider
        self.logIn(handler: handler)
    }
    
    public static func configure() {
        FirebaseApp.configure()
    }
}
