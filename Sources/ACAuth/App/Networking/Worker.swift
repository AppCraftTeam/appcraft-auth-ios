//
//  Worker.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public typealias ExecuteHandler<T: Codable> = (_ result: T?, _ response: HTTPURLResponse?, _ error: ACAuthError?) -> Void

protocol WorkerInterface: AnyObject {
    func execute(_ request: URLRequest, completion: @escaping (_ result: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)
}

class Worker: NSObject, WorkerInterface {
    
    private weak var sessionDelegate: URLSessionDelegate?
    private var activeTasks: [String: URLSessionDataTask]
    private var urlSession: URLSession?
    
    init(sessionConfiguration: URLSessionConfiguration = .default, sessionDelegate: URLSessionDelegate? = nil) {
        self.activeTasks = [:]
        self.sessionDelegate = sessionDelegate
        
        super.init()
        self.urlSession = URLSession(
            configuration: sessionConfiguration,
            delegate: sessionDelegate,
            delegateQueue: nil
        )
    }
        
    func execute(_ request: URLRequest, completion: @escaping (_ result: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        let newTaskUid: String = UUID().uuidString
        let newTask = self.urlSession?.dataTask(with: request, completionHandler: { data, response, error in
            self.activeTasks[newTaskUid]?.cancel()
            self.activeTasks[newTaskUid] = nil
            completion(data, response as? HTTPURLResponse, error)
        })
        self.activeTasks[newTaskUid] = newTask
        self.activeTasks[newTaskUid]?.resume()
    }
}
