//
//  DispatchQueue+BlockInvocation.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

func invoke<T>(
    _ handler: @escaping (T) -> Void,
    in queue: DispatchQueue,
    with result: T
) { queue.async { handler(result) } }

extension DispatchQueue {
    func invoke<T>(_ handler: @escaping (T) -> Void, with result: T) {
        ACAuth.invoke(handler, in: self, with: result)
    }
}
