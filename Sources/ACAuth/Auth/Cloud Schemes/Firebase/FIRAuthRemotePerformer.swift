//
//  FIRAuthRemotePerformer.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// A type describing 3-step firebase authorization with your server.
///
/// The Performer performs the following tasks:
/// 1. Log in to the third party service.
/// 2. Transfer the authorization data to the firebrace provider.
/// 3. Create credentials and log in to the firebase service.
/// 4. Transfer your firebase ID Token to the remote server and get any permissions.
public protocol FIRAuthRemotePerformerProtocol {
    func auth(data: AuthDataResult, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void)
    func auth(with service: FIRAuthPerformer, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void)
    func auth<R: Codable>(data: AuthDataResult, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
    func auth<R: Codable>(with service: FIRAuthPerformer, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
}

/// An object that implements the authorization methods described in ``FIRAuthRemotePerformerProtocol``.
open class FIRAuthRemotePerformer: ServerAuthenticator, FIRAuthRemotePerformerProtocol {
    
    public var provider: FIRRemoteAuthProvider
    
    public convenience init(provider: FIRRemoteAuthProvider) {
        self.init(provider: provider, executor: RequestExecutor())
    }
    
    public init(provider: FIRRemoteAuthProvider, executor: RequestExecutor) {
        self.provider = provider
        super.init(executor: executor)
    }
    
    open func auth(data: AuthDataResult, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void) {
        self.auth(data: data, responseType: JWTToken.self, handler: handler)
    }
    
    open func auth(with service: FIRAuthPerformer, handler: @escaping (Result<JWTToken, ACAuthError>) -> Void) {
        self.auth(with: service, responseType: JWTToken.self, handler: handler)
    }
    
    open func auth<R: Codable>(data: AuthDataResult, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        data.user.getIDToken(completion: { (firebaseIDToken, error) in
            guard let firebaseIDToken = firebaseIDToken else {
                handler(.failure(.firebaseAuthenticationError(reason: .nilWhileUnwrappingFirebaseIDToken(error: error))))
                return
            }
            do {
                let request = try self.generateRequest(firebaseIDToken: firebaseIDToken)
                super.execute(request, response: R.self, handler: handler)
            } catch {
                let error: ACAuthError.RequestError = (error as? ACAuthError.RequestError) ?? .undefined
                handler(.failure(.requestError(reason: error)))
            }
        })
    }

    open func auth<R: Codable>(with service: FIRAuthPerformer, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        service.logIn(handler: { result in
            switch result {
            case let .success(data):
                self.auth(data: data, responseType: responseType, handler: handler)
            case let .failure(error):
                self.outputQueue.async(execute: {
                    handler(.failure(error))
                })
            }
        })
    }
    
    open func generateRequest(firebaseIDToken: String) throws -> URLRequest {
        try URLRequestGenerator(
            source: provider.source,
            method: .post,
            headers: provider.headers,
            parameters: .json([provider.tokenPassingParameterKey: firebaseIDToken])
        ).build()
    }
}
