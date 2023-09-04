//
//  ACFacebookPermissionType.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// A type of permission with string value
public enum ACFacebookPermissionType: String {
    case email = "email"
    case link = "user_link"
    case gender = "user_gender"
    case photos = "user_photos"
    case profile = "public_profile"
    case birthday = "user_birthday"
    case ageRange = "user_age_range"
}
