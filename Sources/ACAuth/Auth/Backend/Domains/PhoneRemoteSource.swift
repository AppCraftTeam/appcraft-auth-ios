//
//  PhoneRemoteSource.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

/// A model of configuration for a phone number authentication provider.
///
/// - `verifyPhoneProvider`: Auth provider configuration structure for phone number.
/// - `verifyCodeAndRemoteAuthProvider`: Auth provider configuration structure for verification code.
public struct PhoneRemoteSource {
    /// Auth provider configuration structure for phone number.
    var verifyPhoneProvider: PSVerifyPhoneProvider
    /// Auth provider configuration structure for verification code.
    var verifyCodeAndRemoteAuthProvider: PSVerifyCodeAndRemoteAuthProvider
}


/// Auth provider configuration structure for phone number.
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct PSVerifyPhoneProvider: RemoteAuthProvider {
    public var source: RemoteSource
    /// Key for transfer phone number. By default: `phone`
    public var phonePassingParameterKey: String = "phone"
}

/// Auth provider configuration structure for verification code.
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct PSVerifyCodeAndRemoteAuthProvider: RemoteAuthProvider {
    public var source: RemoteSource
    /// Key for transfer authorization key from u'r server. By default: `key`
    public var kKeyParameter: String = "key"
    /// Key for transfer authorization code. By default: `code`
    public var kCodeParameter: String = "code"
}
