//
//  ACServerPhoneAuthenticationProtocol.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// An interface that Represents backend authentication by specified phone number.
public protocol ACServerPhoneAuthenticationProtocol {
    
    /// Method for sending a verification code to the specified phone number.
    /// - Parameters:
    ///   - number: The phone number to be verified.
    ///   - handler: A callback block that takes a result with ``ACPhoneAuthoizationKey`` or an ``ACAuthError`` if
    ///             the attempt to verification phone number was unsuccessful.
    ///             By default, the block will be called asynchronously on the `main queue`.
    func verifyPhone(number: String, handler: @escaping (Result<ACPhoneAuthoizationKey, ACAuthError>) -> Void)
    
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
    func verifyCodeAndAuth(key: String, code: String, handler: @escaping (Result<ACJWT, ACAuthError>) -> Void)
    
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
public class ACServerPhoneAuthenticator: ACServerAuthenticator, ACServerPhoneAuthenticationProtocol {
    
    // MARK: Properties
    private var spec: ACPhoneRemoteSpecification
    
    // MARK: - Initialization
    /// Creates `ServerPhoneAuthenticator` with custom request executor.
    /// - Parameters:
    ///   - provider: A model that represents the access specification for a remote application.
    ///   - executor: An object that makes network requests.
    public init(
        spec: ACPhoneRemoteSpecification,
        executor: ACRequestExecutorProtocol
    ) {
        self.spec = spec
        super.init(executor: executor)
    }
    
    /// Creates `ServerPhoneAuthenticator`
    /// - Parameter spec: A model that represents the access specification for a remote application.
    public convenience init(spec: ACPhoneRemoteSpecification) {
        self.init(spec: spec, executor: ACRequestExecutor())
    }
    
    // MARK: - Service methods
    // MARK: Verification
    open func verifyPhone(number: String, handler: @escaping (Result<ACPhoneAuthoizationKey, ACAuthError>) -> Void) {
        self.verifyPhone(number: number, keyResponse: ACPhoneAuthoizationKey.self, handler: handler)
    }
    
    open func verifyPhone<R: Codable>(number: String,keyResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        do {
            let request = try URLRequestGenerator(
                source: spec.verifyPhoneSpec.source,
                headers: spec.verifyPhoneSpec.headers,
                parameters: .json([
                    spec.verifyPhoneSpec.phonePassingParameterKey: number
                ].merge(dict: spec.verifyPhoneSpec.customBodyParameters))
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
    open func verifyCodeAndAuth(key: String, code: String, handler: @escaping (Result<ACJWT, ACAuthError>) -> Void) {
        self.verifyCodeAndAuth(key: key, code: code, tokenResponse: ACJWT.self, handler: handler)
    }
    
    open func verifyCodeAndAuth<R: Codable>(key: String, code: String, tokenResponse codableType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        guard !code.isEmpty else {
            self.outputQueue.invoke(handler, with: .failure(.undefined))
            return
        }
        do {
            let request = try URLRequestGenerator(
                source: spec.verifyPhoneSpec.source,
                headers: spec.verifyPhoneSpec.headers,
                parameters: .json([
                    spec.verifyCodeSpec.kKeyParameter: key,
                    spec.verifyCodeSpec.kCodeParameter: code
                ].merge(dict: spec.verifyPhoneSpec.customBodyParameters))
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

