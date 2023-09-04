//
//  FIRPasswordAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// Firebase Authentication to sign in a user by email/password.
open class FIRPasswordAuthProvider: ACFIRAuthPerformer {
    
    // MARK: Properties
    private let firAuth = Auth.auth()
    
    private var email: String = ""
    private var password: String = ""
    
    var outputQueue: DispatchQueue = .main
    
    // MARK: - Initialization
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public convenience init() {
        self.init(email: "", password: "")
    }
    
    // MARK: - Methods
    open func setupProfile(email: String, password: String) -> Self {
        self.email = email
        self.password = password
        return self
    }
    
    open func resetData() {
        self.email = ""
        self.password = ""
    }
    
    // MARK: - Perform auth

    public func logIn(handler: @escaping ACFIRAuthCallback) {
        guard !email.isEmpty else {
            self.outputQueue.invoke(
                handler,
                with: .failure(.passwordAuthenticationError(reason: .invalidEmail))
            )
            return
        }
        guard !password.isEmpty else {
            self.outputQueue.invoke(
                handler,
                with: .failure(.passwordAuthenticationError(reason: .invalidPassword))
            )
            return
        }
        self.logIn(email: email, password: password, handler: handler)
    }
    
    open func logIn(email: String, password: String, handler: @escaping ACFIRAuthCallback) {
        self.firAuth.signIn(withEmail: email, password: password, completion: { (data, error) in
            self.resetData()
            if let data = data {
                self.outputQueue.invoke(handler, with: .success(data))
            } else {
                self.outputQueue.invoke(
                    handler,
                    with: .failure(.firebaseAuthenticationError(reason: .signInError(error: error)))
                )
            }
        })
    }
}

// MARK: - Fabrication
public extension ACFIRAuthPerformer where Self == FIRPasswordAuthProvider {
    /// Creates performer object that represents `Firebase` authentication with a email and password.
    /// - Returns: Basic authorization performer.
    static func password(email: String, password: String) -> ACFIRAuthPerformer {
        FIRPasswordAuthProvider(email: email, password: password)
    }
}
