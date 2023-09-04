//
//  Dictionary+Merge.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

extension Dictionary {
    func merge(dict: [Key: Value]) -> Self {
        self.merging(dict) { (_, new) in new }
    }
}
