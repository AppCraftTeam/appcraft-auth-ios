//
//  RequestExecutor.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public protocol RequestExecutorProtocol: AnyObject {
    func createTask<T: Codable>(_ request: URLRequest, model: T.Type, handler: @escaping ExecuteHandler<T>)
}

open class RequestExecutor: RequestExecutorProtocol {
    
    var decoder: MapperProtocol = Mapper()
    
    lazy var remoteInterface: WorkerInterface = Worker()
    
    public init() { }
    
    open func createTask<T: Codable>(_ request: URLRequest, model: T.Type, handler: @escaping ExecuteHandler<T>) {
        
        self.remoteInterface.execute(request) { (result, response, error) in
            
            if let error = error {
                if let urlError = error as? URLError {
                    handler(nil, response, ACAuthError.responseError(reason: .dataTask(error: urlError)))
                } else {
                    handler(nil, response, ACAuthError.responseError(reason: .dataTask(error: error)))
                }
                return
            }
            
            if let response = response {
                if !(200...299).contains(response.statusCode) {
                    let error: ACAuthError = .responseError(reason: .invalidHTTPStatusCode(response: response))
                    handler(nil, response, error)
                    return
                }
                if let result = result {
                    self.decoder.map(model: model, data: result, handler: { (result) in
                        switch result {
                        case let .success(model):
                            handler(model, response, nil)
                        case let .failure(error):
                            handler(nil, response, ACAuthError.mapperError(reason: error))
                        }
                    })
                } else {
                    handler(nil, response, nil)
                }
            } else {
                let error: ACAuthError = .responseError(reason: .invalidURLResponse)
                handler(nil, response, error)
            }
        }
    }
}
