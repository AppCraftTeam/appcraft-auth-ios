//
//  Auth+ProxyMethods.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation
import FirebaseAuth

extension Auth {
    
    func link(
        with credential: AuthCredential,
        outputQueue: DispatchQueue,
        completion: ((AuthDataResult?, Error?) -> Void)?
    ) {
        guard let currentUser else {
            outputQueue.async { completion?(nil, nil) }
            return
        }
        currentUser.link(with: credential) { result, error in
            outputQueue.async { completion?(result, error) }
        }
    }
    
    func unlink(fromProvider provider: String, outputQueue: DispatchQueue, completion: ((User?, Error?) -> Void)?) {
        guard let currentUser else {
            outputQueue.async { completion?(nil, nil) }
            return
        }
        currentUser.unlink(fromProvider: provider) { user, error in
            outputQueue.async { completion?(user, error) }
        }
    }
}
