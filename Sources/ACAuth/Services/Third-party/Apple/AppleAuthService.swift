//
//  AppleAuthService.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import AuthenticationServices

/// A callback block that takes a result with ``AppleAuthenticationData`` or an ``ACAuthError/AppleAuthenticationError``
public typealias AppleAuthenticationHandler = (Result<AppleAuthenticationData, ACAuthError.AppleAuthenticationError>) -> Void

/// A type that describing the method of auth in the `Apple`.
public protocol AppleAuthServiceInterface: AnyObject {
    
    /// Log in method.
    ///
    /// Preparation auth data and starts the specified authorization flows during controller initialization
    /// - Parameter handler: A callback block ``AppleAuthenticationHandler``
    func logIn(handler: @escaping AppleAuthenticationHandler)
    
    /// Creating OpenID authorization request that relies on the user’s Apple ID.
    /// - Parameters:
    ///   - scopes: The kinds of contact information that can be requested from the user.
    ///   - nonce: Unique random string nonce.
    /// - Returns: OpenID authorization request.
    func prepareRequest(scopes: [ASAuthorization.Scope], nonce: String) -> ASAuthorizationAppleIDRequest
    
    /// Starts the specified authorization flows during controller initialization.
    /// - Parameters:
    ///   - request: An OpenID authorization request that relies on the user’s Apple ID.
    /// - Parameter handler: A callback block ``AppleAuthenticationHandler``
    func performRequest(_ request: ASAuthorizationAppleIDRequest, handler: @escaping AppleAuthenticationHandler)
}

/// An object that implements the authorization instructions in the ``AuthenticationServices``.
open class AppleAuthService: NSObject, AppleAuthServiceInterface {
    
    private var currentNonce: String = ""
    private var scopes: [ASAuthorization.Scope]
    
    /// Callback that mediates between the `Client` and `AuthenticationServices`.
    private var callback: AppleAuthenticationHandler?
    private let passwordProvider = ASAuthorizationPasswordProvider()
    
    /// Creates `AppleAuthService` instance.
    /// - Parameter scopes: The kinds of contact information that can be requested from the user.
    public init(scopes: [ASAuthorization.Scope]) {
        self.scopes = scopes
    }
    
    open func logIn(handler: @escaping AppleAuthenticationHandler) {
        self.currentNonce = CryptoUtility.randomNonceString()
        
        let request = prepareRequest(
            scopes: scopes,
            nonce: currentNonce
        )
        self.performRequest(request, handler: handler)
    }

    open func prepareRequest(scopes: [ASAuthorization.Scope], nonce: String) -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = scopes
        request.nonce = CryptoUtility.sha256(nonce)
        return request
    }

    open func performRequest(_ request: ASAuthorizationAppleIDRequest, handler: @escaping AppleAuthenticationHandler) {
        self.callback = handler
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [
                request,
                passwordProvider.createRequest()
            ]
        )
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate methods
extension AppleAuthService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.callback?(.failure(.nilWhileUnwrappingAuthorizationAppleIDCredential))
            return
        }
        do {
            let authorizationData = try AppleAuthenticationData(
                credential: credential,
                nonce: currentNonce
            )
            self.callback?(.success(authorizationData))
        } catch {
            guard let error = error as? ACAuthError.AppleAuthenticationError else {
                self.callback?(.failure(.undefinedError))
                return
            }
            self.callback?(.failure(error))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.callback?(.failure(.authorizationError(error: error)))
    }
}
