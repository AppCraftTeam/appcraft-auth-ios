//
//  PhoneAuthoizationKey.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// A model a representing phone authorization key
public struct PhoneAuthoizationKey: Codable {
    
    /// The phone authorization key
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
    }
}
