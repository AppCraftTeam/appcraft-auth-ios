//
//  ACPhoneRemoteSpecification.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

/// A model that represents the access specification for a remote application.
public struct ACPhoneRemoteSpecification {
    /// Specification of the phone number verification method.
    var verifyPhoneSpec: ACVerifyPhoneSpecification
    /// Specification of the code verification method.
    var verifyCodeSpec: ACVerifyCodeSpecification
}


/// Specification of the phone number verification method.
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct ACVerifyPhoneSpecification: ACRemoteMethodSpecification {
    public var source: ACRemoteSource
    /// Key for transfer phone number. By default: `phone`
    public var phonePassingParameterKey: String = "phone"
}

/// Specification of the code verification method.
/// - Note:
/// The described properties will be involved in building `URLRequest`.
public struct ACVerifyCodeSpecification: ACRemoteMethodSpecification {
    public var source: ACRemoteSource
    /// Key for transfer authorization key from u'r server. By default: `key`
    public var kKeyParameter: String = "key"
    /// Key for transfer authorization code. By default: `code`
    public var kCodeParameter: String = "code"
}
