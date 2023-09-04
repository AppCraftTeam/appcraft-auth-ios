//
//  ACServerAuthenticator.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

open class ACServerAuthenticator {
    
    var outputQueue: DispatchQueue = .main
    
    private var executor: ACRequestExecutorProtocol
    
    init(executor: ACRequestExecutorProtocol) {
        self.executor = executor
    }
    
    convenience init() {
        self.init(executor: ACRequestExecutor())
    }
    
    func execute<R: Codable>(_ request: URLRequest, response: R.Type, handler: @escaping (Result<R, ACAuthError>) -> Void) {
        self.executor.createTask(request, model: response, handler: { (data, response, error) in
            self.outputQueue.async(execute: {
                if let data = data {
                    handler(.success(data))
                } else {
                    handler(.failure(error ?? .undefined))
                }
            })
        })
    }
}
