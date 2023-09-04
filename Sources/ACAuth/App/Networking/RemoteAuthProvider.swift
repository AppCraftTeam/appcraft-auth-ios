//
//  RemoteAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public protocol RemoteAuthProvider {
    
    /// Represents a full server path at a certain URL.
    /// Defined via type `string` or `url`.
    var source: RemoteSource { get set }
    
    /// Request headers. By default [:]
    var headers: [String: String] { get set }
    
    /// Request parameters. By default [:]
    var customBodyParameters: [String: Any] { get set }
}

extension RemoteAuthProvider {
    
    public var headers: [String: String] {
        get { [:] }
        set { headers = newValue }
    }
    
    public var customBodyParameters: [String: Any] {
        get { [:] }
        set { customBodyParameters = newValue }
    }
}
