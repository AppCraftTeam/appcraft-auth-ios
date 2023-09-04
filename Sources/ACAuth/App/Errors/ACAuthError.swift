//
//  ACAuthError.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public enum ACAuthError: Error {
    
    /// Represents the error reason during data decoding phase.
    ///
    /// - dataDecodingWithError: Unsuccessful data decoding.
    public enum MapperError: Error {
        /// Unsuccessful data decoding
        /// - Parameters:
        ///   - _error: thrown error.
        case dataDecodingWithError(Error?)
    }
    
    /// Represents the error reason during networking response phase.
    ///
    /// - dataTask: Task error returned by URL loading APIs.
    /// - invalidURLResponse: Nil While Unwrapping response.
    /// - dataTaskURL: Task error codes returned by URL loading APIs.
    /// - invalidHTTPStatusCode: The response contains an invalid HTTP status code.
    public enum ResponseError: Error {
        
        /// Nil while Unwrapping response.
        case invalidURLResponse
        
        /// The response contains an invalid HTTP status code.
        /// - Note:
        ///   By default, status code `200..<299` is recognized as valid.
        /// - Parameters:
        ///   - response: Received response.
        case invalidHTTPStatusCode(response: HTTPURLResponse)
        
        /// Task error codes returned by URL loading APIs.
        /// - Parameters:
        ///   - error: Unwrapped URLError.
        case dataTaskURL(error: URLError)
        
        /// Task error returned by URL loading APIs.
        /// - Parameters:
        ///   - error: Received underlying optinal error.
        case dataTask(error: Error?)
    }
    
    /// Represents the error reason during building request phase.
    ///
    /// - undefined: Undefined error
    /// - invalidURL: The URL of request is `nil` or empty
    /// - serializationBody: Unsuccessful data encoding.
    public enum RequestError: Error {
        /// The URL of request is `nil` or empty.
        case invalidURL
        /// Undefined error
        case undefined
        /// Unsuccessful data encoding
        /// - Parameters:
        ///   - error: thrown error.
        case serializationBody(error: Error)
    }
    
    /// Represents the error reason during apple auth phase.
    ///
    /// - invalidNonce: The nounce is empty.
    /// - undefinedError: Undefined error.
    /// - authorizationError: Apple auth error.
    /// - nilWhileUnwrappingAuthorizationToken: Nil while unwrapping `AuthorizationToken`.
    /// - nilWhileUnwrappingAuthorizationAppleIDCredential: Nil while unwrapping `IDCredential`.
    public enum ACAppleAuthenticationError: Error {
        /// The nounce is empty.
        case invalidNonce
        /// Undefined error.
        case undefinedError
        /// Apple auth error.
        /// - Parameters:
        ///   - error: Received underlying error.
        case authorizationError(error: Error)
         /// Nil while unwrapping `AuthorizationToken`.
        case nilWhileUnwrappingAuthorizationToken
        /// Nil while unwrapping `IDCredential`.
        case nilWhileUnwrappingAuthorizationAppleIDCredential
    }
    
    /// Represents the error reason during facebook auth phase.
    ///
    /// - logInError: Facebook auth error.
    /// - nilWhileUnwrappingTargetView: Nil while unwrapping `TargetView`.
    /// - nilWhileUnwrappingAccessToken: Nil while unwrapping `AccessToken`.
    public enum FacebookAuthenticationError: Error {
        /// Facebook auth error.
        /// - Parameters:
        ///   - error: Received underlying Facebook error.
        case logInError(error: Error)
        /// Nil while unwrapping `AccessToken`.
        case nilWhileUnwrappingAccessToken
    }
    
    /// Represents the error reason during vk auth phase.
    ///
    /// - undefined: Undefined error
    /// - captchaError: Captcha error
    public enum VKAuthenticationError: Error {
        /// Undefined error
        case undefined
        /// Captcha error
        /// - Parameters:
        ///   - error: Received underlying error.
        case captchaError(error: Error)
    }
    
    /// Represents the error reason during firebase auth phase.
    ///
    /// - signInError: Firebase sign in error with `FIRAuthErrors`.
    /// - nilWhileUnwrappingCredential: Nil while unwrapping `credential` with received optional error.
    /// - nilWhileUnwrappingFirebaseIDToken: Nil while unwrapping firebase `IDToken` with received optional error.
    public enum FIRAuthenticationError: Error {
        /// Firebase sign in error.
        /// - Parameters:
        ///   - error: Received optional case from `FIRAuthErrors`.
        case signInError(error: Error?)
        /// Nil while unwrapping `credential` with received optional error.
        /// - Parameters:
        ///   - error: Received underlying optional error.
        case nilWhileUnwrappingCredential(error: Error?)
        /// Nil while unwrapping firebase `IDToken` with received optional error.
        /// - Parameters:
        ///   - error: Received underlying optional error.
        case nilWhileUnwrappingFirebaseIDToken(error: Error?)
    }
    
    /// Represents the error reason during google auth phase.
    ///
    /// - signInError: Google sign in error.
    /// - nilWhileUnwrappingTargetView: Nil while unwrapping `TargetView`.
    /// - nilWhileUnwrappingFIRClientID: Nil while unwrapping `FIRClientID`.
    /// - nilWhileUnwrappingAuthenticationObject: Nil while unwrapping `AuthenticationObject`.
    /// - fetchIDTokenError: Unsuccessful receipt `IDToken` with underlying error.
    public enum GoogleAuthenticationError: Error {
        /// Google sign in error.
        /// - Parameters:
        ///   - error: Received underlying optional error.
        case signInError(error: Error?)
        ///  Nil while unwrapping `TargetView`.
        case nilWhileUnwrappingTargetView
        /// Nil while unwrapping `FIRClientID`.
        case nilWhileUnwrappingFIRClientID
        /// Nil while unwrapping `AuthenticationObject`.
        case nilWhileUnwrappingAuthenticationObject
        /// Unsuccessful receipt `IDToken` with underlying error.
        /// - Parameters:
        ///   - error: Received underlying optional error.
        case fetchIDTokenError(error: Error?)
    }
    
    /// Represents the error reason during phone auth phase.
    ///
    /// - specifiedCodeIsEmpty: Specified `Code` is empty.
    /// - nilWhileUnwrappingRequestKey: Nil while unwrapping `Request Key`.
    public enum PhoneAuthenticationError: Error {
        /// Specified code is empty
        case specifiedCodeIsEmpty
        /// Nil while unwrapping Request Key
        case nilWhileUnwrappingRequestKey
    }
    
    /// Represents the error reason during password auth phase.
    ///
    /// - invalidEmail: Invalid Email format.
    /// - invalidPassword: Invalid Password format.
    public enum PasswordAuthenticationError: Error {
        /// - invalidEmail: Invalid Email format
        case invalidEmail
        /// - invalidPassword: Invalid Password format.
        case invalidPassword
    }
    
    /// Represents the error reason during data decoding phase.
    case mapperError(reason: MapperError)
    /// Represents the error reason during building request phase.
    case requestError(reason: RequestError)
    /// Represents the error reason during networking response phase.
    case responseError(reason: ResponseError)
    /// Represents the error reason during vk auth phase.
    case vkAuthenticationError(reason: VKAuthenticationError)
    /// Represents the error reason during apple auth phase.
    case appleAuthenticationError(reason: ACAppleAuthenticationError)
    /// Represents the error reason during firebase auth phase.
    case firebaseAuthenticationError(reason: FIRAuthenticationError)
    /// Represents the error reason during google auth phase.
    case googleAuthenticationError(reason: GoogleAuthenticationError)
    /// Represents the error reason during facebook auth phase.
    case facebookAuthorizationError(reason: FacebookAuthenticationError)
    /// Represents the error reason during phone auth phase.
    case phoneAuthenticationError(reason: PhoneAuthenticationError)
    /// Represents the error reason during password auth phase.
    case passwordAuthenticationError(reason: PasswordAuthenticationError)
    /// Represents undefined error
    case undefined
}

// MARK: - FIRAuthenticationError errorDescription
extension ACAuthError.FIRAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "Firebase auth failed."
        switch self {
        case let .signInError(error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "\(prefix) Error: \(localizedDescription)"
        case let .nilWhileUnwrappingCredential(error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "\(prefix) Reason: nil while unwrapping credential. The underlying error: \(localizedDescription)"
        case let .nilWhileUnwrappingFirebaseIDToken(error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "\(prefix) Reason: nil while unwrapping FirebaseIDToken. The underlying error: \(localizedDescription)"
        }
    }
}

// MARK: - GoogleAuthenticationError errorDescription
extension ACAuthError.GoogleAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "Google auth failed."
        switch self {
        case .nilWhileUnwrappingTargetView:
            return "\(prefix) Reason: nil while unwrapping TargetView."
        case .nilWhileUnwrappingFIRClientID:
            return "\(prefix) Reason: nil while unwrapping FIRClientID."
        case .nilWhileUnwrappingAuthenticationObject:
            return "\(prefix) Reason: nil while unwrapping AuthenticationObject."
        case .signInError(let error), .fetchIDTokenError(let error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "\(prefix) The underlying error: \(localizedDescription)"
        }
    }
}

// MARK: - FacebookAuthenticationError errorDescription
extension ACAuthError.FacebookAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "Facebook auth failed."
        switch self {
        case let .logInError(error):
            return "\(prefix) The underlying error: \(error.localizedDescription)"
        case .nilWhileUnwrappingAccessToken:
            return "\(prefix) Reason: nil while unwrapping AccessToken."
        }
    }
}

// MARK: - VKAuthenticationError errorDescription
extension ACAuthError.VKAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "VK auth failed."
        switch self {
        case .undefined:
            return "\(prefix) Undefined error."
        case let .captchaError(error):
            return "\(prefix) Captcha error: \(error.localizedDescription)"
        }
    }
}

// MARK: - RequestError errorDescription
extension ACAuthError.RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request is nil or empty URL."
        case let .serializationBody(error):
            return "Serialization body error. The underlying error: \(error.localizedDescription)"
        case .undefined:
            return "Undefined request error."
        }
    }
}

// MARK: - ResponseError errorDescription
extension ACAuthError.ResponseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURLResponse:
            return "Nil while Unwrapping response."
        case let .invalidHTTPStatusCode(response):
            return "The HTTP status code in response is invalid. Code: \(response.statusCode), response: \(response)."
        case let .dataTask(error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "The session task was cancelled with error. The underlying error: \(localizedDescription)"
        case let .dataTaskURL(error):
            return "The session task was cancelled with error. The underlying error: \(error.localizedDescription)"
        }
    }
}

// MARK: - ACAppleAuthenticationError errorDescription
extension ACAuthError.ACAppleAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "Apple auth failed."
        switch self {
        case .invalidNonce:
            return "\(prefix) The nounce is empty."
        case .undefinedError:
            return "\(prefix) Undefined error."
        case .nilWhileUnwrappingAuthorizationToken:
            return "\(prefix) Reason: nil while unwrapping AuthorizationToken."
        case let .authorizationError(error):
            return "\(prefix) The underlying error: \(error.localizedDescription)"
        case .nilWhileUnwrappingAuthorizationAppleIDCredential:
            return "\(prefix) Reason: nil while unwrapping AuthorizationAppleIDCredential."
        }
    }
}
// MARK: - MapperError errorDescription
extension ACAuthError.MapperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .dataDecodingWithError(error):
            let localizedDescription = String(describing: error?.localizedDescription)
            return "Decoding received data failed. The underlying error: \(localizedDescription)"
        }
    }
}

// MARK: - PhoneAuthenticationError
extension ACAuthError.PhoneAuthenticationError: LocalizedError {
    public var errorDescription: String? {
        let prefix = "Phone auth failed."
        switch self {
        case .nilWhileUnwrappingRequestKey:
            return "\(prefix) Reason: nil while unwrapping request key."
        case .specifiedCodeIsEmpty:
            return "\(prefix) Reason: Specified code is empty."
        }
    }
}

// MARK: - PasswordAuthError
extension ACAuthError.PasswordAuthenticationError {
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidPassword:
            return "Invalid password"
        }
    }
}
// MARK: - ACAuthError errorDescription
extension ACAuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .undefined:
            return "Undefined error."
        case let .mapperError(reason):
            return reason.errorDescription
        case let .requestError(reason):
            return reason.errorDescription
        case let .responseError(reason):
            return reason.errorDescription
        case let .vkAuthenticationError(reason):
            return reason.errorDescription
        case let .appleAuthenticationError(reason):
            return reason.errorDescription
        case let .facebookAuthorizationError(reason):
            return reason.errorDescription
        case let .firebaseAuthenticationError(reason):
            return reason.errorDescription
        case let .googleAuthenticationError(reason):
            return reason.errorDescription
        case let .phoneAuthenticationError(reason):
            return reason.errorDescription
        case let .passwordAuthenticationError(reason):
            return reason.errorDescription
        }
    }
}
