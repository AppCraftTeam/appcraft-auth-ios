//
//  GoogleAuthServiceRestoreSignInState.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public enum GoogleAuthServiceRestoreSignInState {
    case signOut(error: Error?)
    case signIn(profile: GoogleProfile?)
}
