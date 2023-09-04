//
//  FIRGoogleAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Firebase
import GoogleSignIn

/// A provider object that represents `Firebase` authentication with `Google`.
open class FIRGoogleAuthProvider: ACFIRAuthProvider, ACFIRAuthPerformer {
    
    // MARK: Properties
    private let googleService: ACGoogleAuthServiceInterface
    
    // MARK: - Initialization
    /// Creates ``FIRGoogleAuthProvider`` instance with custom auth service
    ///
    /// The area for presenting auth window should be defined in ``ACGoogleAuthServiceInterface``.
    /// - Parameter service: Represents Google auth service.
    public init(service: ACGoogleAuthServiceInterface) {
        self.googleService = service
    }
    
    /// Creates `FIRGoogleAuthProvider`
    /// - Parameters:
    ///   - configuration: This class represents the client configuration provided by the developer.
    ///   - targetView: Area for auth window
    public init(configuration: GIDConfiguration, targetView: UIViewController?) {
        self.googleService = ACGoogleAuthService(
            configuration: configuration,
            targetView: targetView
        )
    }
    
    /// Creates `FIRGoogleAuthProvider`
    ///
    /// By default, the topmost view controller in the navigation stack must be used as the target of the view.
    /// - Parameter configuration: This class represents the client configuration provided by the developer.
    public convenience init(configuration: GIDConfiguration) {
        self.init(configuration: configuration, targetView: .topViewController)
    }
    
    // MARK: - Perform auth
    /// Description
    /// - Parameter handler: handler description
    open func logIn(handler: @escaping ACFIRAuthCallback) {
        self.googleService.signIn(handler: { (result) in
            switch result {
            case let .success(profile):
                if let idToken = profile.idToken {
                    let credential = GoogleAuthProvider.credential(
                        withIDToken: idToken,
                        accessToken: profile.accessToken
                    )
                    self.signIn(with: credential, handler: handler)
                } else {
                    self.outputQueue.async {
                        handler(.failure(.googleAuthenticationError(reason: .nilWhileUnwrappingAuthenticationObject)))
                    }
                }
            case let .failure(error):
                self.outputQueue.async {
                    handler(.failure(.googleAuthenticationError(reason: error)))
                }
            }
        })
    }
}

// MARK: - Fabrication
public extension ACFIRAuthPerformer where Self == FIRGoogleAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Google`.
    /// - Parameters:
    ///   - clientID: Permission list. See more ``ACFacebookPermissionType``.
    ///   - targetView: The view controller to present from.
    /// - Returns: Google authorization performer.
    static func google(clientID: String, targetView: UIViewController? = .topViewController) -> ACFIRAuthPerformer {
        FIRGoogleAuthProvider(configuration: .init(clientID: clientID), targetView: targetView)
    }
}
