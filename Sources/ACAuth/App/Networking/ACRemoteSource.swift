//
//  ACRemoteSource.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public protocol ACRemoteSource {
    var targetURL: URL? { get }
}

extension String: ACRemoteSource {
    public var targetURL: URL? { URL(string: self) }
}

extension URL: ACRemoteSource {
    public var targetURL: URL? { self }
}
