//
//  ACFIRPhoneAuthProvider.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import FirebaseAuth

/// Firebase Authentication to sign in a user by sending an SMS message to the user's phone.
open class ACFIRPhoneAuthProvider: ACFIRAuthProvider {
   
    /// Authentication Key
    private var verificationID: String? {
        get { UserDefaults.standard.string(forKey: "verification.id") }
        set { UserDefaults.standard.set(newValue, forKey: "verification.id") }
    }
    
    private let provider = PhoneAuthProvider.provider()
    
    /// Starts the phone number authentication flow by sending a verification code to the specified phone number.
    /// - Parameters:
    ///   - number: Phone number. Goes through a formatting process.
    ///   - handler: The callback to be invoked when the verification flow is finished.
    open func verifyPhone(@ACPhoneFormatter number: String, handler: @escaping (Result<String, ACAuthError>) -> Void) {
        self.provider.verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            guard let verificationID = verificationID else {
                self.outputQueue.invoke(handler, with: .failure(.undefined))
                return
            }
            self.verificationID = verificationID
            self.outputQueue.invoke(handler, with: .success(verificationID))
        }
    }
    
    /// Asynchronously signs in to Firebase with the given 3rd-party credentials
    /// and returns additional identity provider data.
    ///
    /// - Parameters:
    ///   - handler: Invoked asynchronously on the main thread in the future and included `Result` with helper object that contains the result of a successful sign-in, link and reauthenticate action.
    open func verifyCodeAndAuth(code: String, handler: @escaping ACFIRAuthCallback) {
        guard let key = verificationID else {
            self.outputQueue.invoke(
                handler,
                with: .failure(.phoneAuthenticationError(reason: .nilWhileUnwrappingRequestKey))
            )
            return
        }
        guard !code.isEmpty else {
            self.outputQueue.invoke(
                handler,
                with: .failure(.phoneAuthenticationError(reason: .specifiedCodeIsEmpty))
            )
            return
        }
        let credential = self.provider.credential(
            withVerificationID: key,
            verificationCode: code
        )
        self.signIn(with: credential, handler: { result in
            guard let data = try? result.get() else {
                handler(result)
                return
            }
            self.verificationID = nil
            handler(.success(data))
        })
    }
}

