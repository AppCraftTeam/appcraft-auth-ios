//
//  ACGoogleAuthServiceRestoreSignInState.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public enum ACGoogleAuthServiceRestoreSignInState {
    case signOut(error: Error?)
    case signIn(profile: ACGoogleProfile?)
}
