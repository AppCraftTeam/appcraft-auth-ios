//
//  FIRFacebookAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import UIKit
import FirebaseAuth
import FacebookLogin

/// A provider object that represents `Firebase` authentication with a `Facebook`.
open class FIRFacebookAuthProvider: FIRAuthProvider, FIRAuthPerformer {

    // MARK: Properties
    private let facebookService: FacebookAuthServiceInterface
    
    // MARK: - Initialization
    
    /// Creates `FIRAppleAuthProvider` instance with custom auth service.
    /// - Parameters:
    ///   - service: Facebook authorization service. See more ``FacebookAuthServiceInterface``.
    public init(service: FacebookAuthServiceInterface) {
        self.facebookService = service
    }
    
    /// Creates `FIRAppleAuthProvider` instance.
    /// - Parameters:
    ///   - permissions: Permission list. See more ``FacebookPermissionType``.
    ///   - targetView: The view controller to present from.
    public init(permissions: [FacebookPermissionType], targetView: UIViewController?) {
        self.facebookService = FacebookAuthService(permissions: permissions, targetView: targetView)
    }
    /// Creates `FIRAppleAuthProvider` instance.
    ///
    /// By default, the topmost view controller in the navigation stack must be used as the target of the view.
    public convenience init(permissions: [FacebookPermissionType]) {
        self.init(permissions: permissions, targetView: .topViewController)
    }
    
    // MARK: - Perform auth
    open func logIn(handler: @escaping FIRAuthCallback) {
        self.facebookService.signIn(handler: { (result) in
            switch result {
            case let .success(token):
                let credential = FacebookAuthProvider.credential(
                    withAccessToken: token.tokenString
                )
                self.signIn(with: credential, handler: handler)
            case let .failure(error):
                self.outputQueue.async {
                    handler(.failure(.facebookAuthorizationError(reason: error)))
                }
            }
        })
    }
}

// MARK: - Fabrication
public extension FIRAuthPerformer where Self == FIRFacebookAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Facebook`.
    /// - Parameters:
    ///   - permissions: Permission list. See more ``FacebookPermissionType``.
    ///   - targetView: The view controller to present from.
    /// - Returns: Facebook authorization performer.
    static func facebook(
        permissions: [FacebookPermissionType],
        targetView: UIViewController? = .topViewController
    ) -> FIRAuthPerformer {
        FIRFacebookAuthProvider(permissions: permissions, targetView: targetView)
    }
}
