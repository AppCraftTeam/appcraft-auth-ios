//
//  ServerPhoneAuthenticationProtocol.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// An interface that Represents backend authentication by specified phone number.
public protocol ServerPhoneAuthenticationProtocol {
    
    /// Method for sending a verification code to the specified phone number.
    /// - Parameters:
    ///   - number: The phone number to be verified.
    ///   - handler: A callback block that takes a result with ``PhoneAuthoizationKey`` or an ``ACAuthError`` if
    ///             the attempt to verification phone number was unsuccessful.
    ///             By default, the block will be called asynchronously on the `main queue`.
    func verifyPhone(number: String, handler: @escaping (Result<PhoneAuthoizationKey, ACAuthError>) -> Void)
    
    /// Method for sending a verification code to the specified phone number with generic key type.
    /// - Parameters:
    ///   - number: The phone number to be verified.
    ///   - handler: A callback block that takes a result with `generic type` which conform to `Codable`
    ///             or an `ACAuthError` if the attempt to verification phone number was unsuccessful.
    ///             By default, yhe block will be called asynchronously on the `main queue`.
    func verifyPhone<R: Codable>(number: String, keyResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
    
    /// Method for verification specified code.
    /// - Parameters:
    ///   - key: SMS request key.
    ///   - code: SMS code.
    ///   - handler: A callback block that takes a result with ``JWTToken`` or an ``ACAuthError`` if the attempt
    ///             to verification request key and specified code was unsuccessful.
    ///             By default, yhe block will be called asynchronously on the `main queue`.
    func verifyCodeAndAuth(key: String, code: String, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void)
    
    /// Method for verification specified code with generic token type.
    /// - Parameters:
    ///   - key: SMS request key.
    ///   - code: SMS code.
    ///   - handler: A callback block that takes a result with `generic type` which conform to `Codable`
    ///             or an `ACAuthError` if the attempt to verification request key and specified code was unsuccessful.
    ///             By default, yhe block will be called asynchronously on the `main queue`.
    func verifyCodeAndAuth<R: Codable>(key: String, code: String, tokenResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
}

/// External backend authentication to sign in a user by sending an SMS message to the user's phone.
public class ServerPhoneAuthenticator: ServerAuthenticator, ServerPhoneAuthenticationProtocol {
    
    // MARK: Properties
    private var provider: PhoneRemoteSource
    
    // MARK: - Initialization
    /// Creates `ServerPhoneAuthenticator` with custom request executor.
    /// - Parameters:
    ///   - provider: A model of configuration for a phone number authentication provider.
    ///   - executor: An object that makes network requests.
    public init(provider: PhoneRemoteSource, executor: RequestExecutorProtocol) {
        self.provider = provider
        super.init(executor: executor)
    }
    
    /// Creates `ServerPhoneAuthenticator`
    /// - Parameter provider: A model of configuration for a phone number authentication provider.
    public convenience init(provider: PhoneRemoteSource) {
        self.init(provider: provider, executor: RequestExecutor())
    }
    
    // MARK: - Service methods
    // MARK: Verification
    open func verifyPhone(number: String, handler: @escaping (Result<PhoneAuthoizationKey, ACAuthError>) -> Void) {
        self.verifyPhone(number: number, keyResponse: PhoneAuthoizationKey.self, handler: handler)
    }
    
    open func verifyPhone<R: Codable>(number: String,keyResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        do {
            let request = try URLRequestGenerator(
                source: provider.verifyPhoneProvider.source,
                headers: provider.verifyPhoneProvider.headers,
                parameters: .json([
                    provider.verifyPhoneProvider.phonePassingParameterKey: number
                ].merge(dict: provider.verifyPhoneProvider.customBodyParameters))
            ).build()
            super.execute(request, response: codableType, handler: handler)
        } catch {
            self.outputQueue.async {
                let error: ACAuthError.RequestError = (error as? ACAuthError.RequestError) ?? .undefined
                handler(.failure(.requestError(reason: error)))
            }
        }
    }
    
    // MARK: Authentication
    open func verifyCodeAndAuth(key: String, code: String, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void) {
        self.verifyCodeAndAuth(key: key, code: code, tokenResponse: JWTToken.self, handler: handler)
    }
    
    open func verifyCodeAndAuth<R: Codable>(key: String, code: String, tokenResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        guard !code.isEmpty else {
            self.outputQueue.invoke(handler, with: .failure(.undefined))
            return
        }
        do {
            let request = try URLRequestGenerator(
                source: provider.verifyPhoneProvider.source,
                headers: provider.verifyPhoneProvider.headers,
                parameters: .json([
                    provider.verifyCodeAndRemoteAuthProvider.kKeyParameter: key,
                    provider.verifyCodeAndRemoteAuthProvider.kCodeParameter: code
                ].merge(dict: provider.verifyPhoneProvider.customBodyParameters))
            ).build()
            super.execute(request, response: codableType, handler: handler)
        } catch {
            self.outputQueue.async {
                let error: ACAuthError.RequestError = (error as? ACAuthError.RequestError) ?? .undefined
                handler(.failure(.requestError(reason: error)))
            }
        }
    }
}

