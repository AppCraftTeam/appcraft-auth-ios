//
//  ACFIRAuthCallback.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// A callback block that takes a result with [AuthDataResult](https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Classes) or an ``ACAuthError``.
public typealias ACFIRAuthCallback = (Result<AuthDataResult, ACAuthError>) -> Void
