//
//  GoogleProfile.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import GoogleSignIn

/// A model representing of basic google profile.
public struct GoogleProfile {
    
    /// The Google user ID.
    var id: String?
    
    /// Token id.
    var idToken: String?
    
    /// Access token.
    var accessToken: String
    
    /// The Google user's email.
    var email: String?
    
    /// The Google user's full name.
    var name: String?
    
    /// The Google user's family name.
    var familyName: String?
    
    /// The Google user's given name.
    var givenName: String?
}
