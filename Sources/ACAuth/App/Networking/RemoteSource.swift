//
//  RemoteSource.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

public protocol RemoteSource {
    var targetURL: URL? { get }
}

extension String: RemoteSource {
    public var targetURL: URL? { URL(string: self) }
}

extension URL: RemoteSource {
    public var targetURL: URL? { self }
}
