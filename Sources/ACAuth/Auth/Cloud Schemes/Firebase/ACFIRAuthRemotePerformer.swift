//
//  ACFIRAuthRemotePerformer.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

public typealias ACFIRPerformerResult = Result<ACJWT, ACAuthError>

/// A type describing 3-step firebase authorization with your server.
///
/// The Performer performs the following tasks:
/// 1. Log in to the third party service.
/// 2. Transfer the authorization data to the firebrace provider.
/// 3. Create credentials and log in to the firebase service.
/// 4. Transfer your firebase ID Token to the remote server and get any permissions.
public protocol ACFIRAuthRemotePerformerProtocol {
    func auth(data: AuthDataResult, handler: @escaping (ACFIRPerformerResult) -> Void)
    func auth(with service: ACFIRAuthPerformer, handler: @escaping (ACFIRPerformerResult) -> Void)
    func auth<R: Codable>(data: AuthDataResult, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
    func auth<R: Codable>(with service: ACFIRAuthPerformer, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void)
}

/// An object that implements the authorization methods described in ``ACFIRAuthRemotePerformerProtocol``.
open class ACFIRAuthRemotePerformer: ACServerAuthenticator, ACFIRAuthRemotePerformerProtocol {
    
    public var spec: ACFIRRemoteSpecification
    
    public convenience init(spec: ACFIRRemoteSpecification) {
        self.init(spec: spec, executor: ACRequestExecutor())
    }
    
    public init(spec: ACFIRRemoteSpecification, executor: ACRequestExecutor) {
        self.spec = spec
        super.init(executor: executor)
    }
    
    open func auth(data: AuthDataResult, handler: @escaping (ACFIRPerformerResult) -> Void) {
        self.auth(data: data, responseType: ACJWT.self, handler: handler)
    }
    
    open func auth(with service: ACFIRAuthPerformer, handler: @escaping (ACFIRPerformerResult) -> Void) {
        self.auth(with: service, responseType: ACJWT.self, handler: handler)
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

    open func auth<R: Codable>(with service: ACFIRAuthPerformer, responseType: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
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
            source: spec.source,
            method: .post,
            headers: spec.headers,
            parameters: .json([spec.tokenPassingParameterKey: firebaseIDToken])
        ).build()
    }
}
