//
//  JWTToken.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// A model representing JWT.
public struct JWTToken: Codable {
    ///
    let access: String
    /// 
    let refresh: String
    
    enum CodingKeys: String, CodingKey {
        case access = "accessToken"
        case refresh = "refreshToken"
    }
}
