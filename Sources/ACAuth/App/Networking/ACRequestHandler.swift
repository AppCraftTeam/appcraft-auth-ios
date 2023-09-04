//
//  ACRequestHandler.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public typealias ACRequestHandler<T: Codable> = (_ result: T?, _ response: HTTPURLResponse?, _ error: ACAuthError?) -> Void
