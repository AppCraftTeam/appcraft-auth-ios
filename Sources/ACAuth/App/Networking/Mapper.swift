//
//  Mapper.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

typealias MapperHandler<T> = (Result<T, ACAuthError.MapperError>) -> Void

protocol MapperProtocol {
    func map<T: Decodable>(model: T.Type, data: Data, handler: MapperHandler<T>)
    func map<T: Decodable>(model: T.Type, text: String, handler: MapperHandler<T>)
}

class Mapper: MapperProtocol {

    private let decoder = JSONDecoder()
    
    func map<T: Decodable>(model: T.Type, text: String, handler: MapperHandler<T>) {
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else {
            handler(.failure(.dataDecodingWithError(nil)))
            return
        }
        self.map(model: model, data: data, handler: handler)
    }
    
    func map<T: Decodable>(model: T.Type, data: Data, handler: MapperHandler<T>) {
        do {
            let model = try decoder.decode(model, from: data)
            handler(.success(model))
        } catch let error {
            handler(.failure(.dataDecodingWithError(error)))
        }
    }
}
