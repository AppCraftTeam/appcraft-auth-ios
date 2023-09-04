//
//  ACFIRFacebookAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import UIKit
import FirebaseAuth
import FacebookLogin

/// A provider object that represents `Firebase` authentication with a `Facebook`.
open class ACFIRFacebookAuthProvider: ACFIRAuthProvider, ACFIRAuthPerformer {

    // MARK: Properties
    private let facebookService: ACFacebookAuthServiceInterface
    
    // MARK: - Initialization
    
    /// Creates `FIRAppleAuthProvider` instance with custom auth service.
    /// - Parameters:
    ///   - service: Facebook authorization service. See more ``ACFacebookAuthServiceInterface``.
    public init(service: ACFacebookAuthServiceInterface) {
        self.facebookService = service
    }
    
    /// Creates `FIRAppleAuthProvider` instance.
    /// - Parameters:
    ///   - permissions: Permission list. See more ``ACFacebookPermissionType``.
    ///   - targetView: The view controller to present from.
    public init(permissions: [ACFacebookPermissionType], targetView: UIViewController?) {
        self.facebookService = ACFacebookAuthService(permissions: permissions, targetView: targetView)
    }
    /// Creates `FIRAppleAuthProvider` instance.
    ///
    /// By default, the topmost view controller in the navigation stack must be used as the target of the view.
    public convenience init(permissions: [ACFacebookPermissionType]) {
        self.init(permissions: permissions, targetView: .topViewController)
    }
    
    // MARK: - Perform auth
    open func logIn(handler: @escaping ACFIRAuthCallback) {
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
public extension ACFIRAuthPerformer where Self == ACFIRFacebookAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a `Facebook`.
    /// - Parameters:
    ///   - permissions: Permission list. See more ``ACFacebookPermissionType``.
    ///   - targetView: The view controller to present from.
    /// - Returns: Facebook authorization performer.
    static func facebook(
        permissions: [ACFacebookPermissionType],
        targetView: UIViewController? = .topViewController
    ) -> ACFIRAuthPerformer {
        ACFIRFacebookAuthProvider(permissions: permissions, targetView: targetView)
    }
}
