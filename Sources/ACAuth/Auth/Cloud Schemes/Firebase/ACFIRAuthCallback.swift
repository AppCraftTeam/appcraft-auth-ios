//
//  ACFIRAuthCallback.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// A callback block that takes a ``ACFIRAuthResult``.
public typealias ACFIRAuthCallback = (ACFIRAuthResult) -> Void

/// The result of authorization in the Firebase service.
///
/// Result is enum with [AuthDataResult](https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Classes) or an ``ACAuthError``
public typealias ACFIRAuthResult = Result<AuthDataResult, ACAuthError>
