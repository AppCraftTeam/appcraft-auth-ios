//
//  ACPhoneFormatter.swift
//  ACAuth
//
//  Created by AppCraft LLC on 31.08.2023.
//

import Foundation

/// By default, occurrences for trimming: (" ", "-", "(", ")", "+")
@propertyWrapper
public struct ACPhoneFormatter {
    
    private var value: String
    private var occurrences: [String]
    
    public var wrappedValue: String {
        get {
            occurrences.reduce(into: value) { (output, char) in
                output = output.replacingOccurrences(of: char, with: "")
            }
        }
        set { value = newValue }
    }
            
    public init(wrappedValue: String) {
        self.value = wrappedValue
        self.occurrences = [" ", "-", "(", ")", "+"]
    }

    public init(wrappedValue: String, occurrences: [String]) {
        self.value = wrappedValue
        self.occurrences = occurrences
    }
}
