//
//  ACFIRAuthPerformer.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

/// Auth protocol for Firebase services.
public protocol ACFIRAuthPerformer {
    /// Log in proxy method.
    ///
    /// A method that performs authorization in a third-party service, then creates credentials data for authorization in the Firebase.
    ///
    /// - Parameter handler: A callback block ``ACFIRAuthCallback``. By default, invoke in `main queue`.
    func logIn(handler: @escaping ACFIRAuthCallback)
}
