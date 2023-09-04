//
//  FIRRemoteAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

/// A set of properties for `authentication provider` via `firebase`.
///
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct FIRRemoteAuthProvider: RemoteAuthProvider {
    
    public var source: RemoteSource
    /// Key for transfer firebase authorization token. By default: `code`
    public var tokenPassingParameterKey: String = "firebaseToken"
}
