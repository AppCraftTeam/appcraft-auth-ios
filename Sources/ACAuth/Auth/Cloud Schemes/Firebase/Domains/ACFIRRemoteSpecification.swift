//
//  ACFIRRemoteSpecification.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

/// A model that represents the access specification for a remote application.
///
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct ACFIRRemoteSpecification: ACRemoteMethodSpecification {
    
    public var source: ACRemoteSource
    /// Key for transfer firebase authorization token. By default: `code`
    public var tokenPassingParameterKey: String = "firebaseToken"
}
