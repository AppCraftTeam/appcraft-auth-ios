//
//  HTTPMethod.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    
    public var stringValue: String {
        return self.rawValue
    }
}

enum RequestParams {
    case json([String: Any])
    case none
    
    var data: [String: Any] {
        switch self {
        case .none: return [:]
        case let .json(data): return data
        }
    }
}

protocol RequestBuilder {
    func build() throws -> URLRequest
}

class URLRequestGenerator: RequestBuilder {
    
    var targetURL: URL?
    var method: HTTPMethod = .get
    var headers: [String: String]?
    var bodyObject: Encodable?
    var parameters: RequestParams
    
    init(
        source: RemoteSource,
        method: HTTPMethod = .get,
        headers: [String: String]?,
        parameters: RequestParams,
        bodyObject: Encodable? = nil
    ) throws {
        guard let url = source.targetURL else {
            throw ACAuthError.requestError(reason: .invalidURL)
        }
        self.targetURL = url
        self.method = method
        self.headers = headers
        self.bodyObject = bodyObject
        self.parameters = parameters
    }
    
    func build() throws -> URLRequest {
        guard let targetURL = targetURL, targetURL.absoluteString.isEmpty else {
            throw ACAuthError.requestError(reason: .invalidURL)
        }
        var request = URLRequest(
            url: targetURL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15
        )
        request.httpMethod = method.rawValue
        headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        try buildRequestParameters(&request, parameters: parameters)
        return request
    }
    
    private func buildRequestParameters(_ req: inout URLRequest, parameters: RequestParams) throws {
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: parameters.data, options: [])
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        catch {
            throw ACAuthError.requestError(reason: .serializationBody(error: error))
        }
    }
}
