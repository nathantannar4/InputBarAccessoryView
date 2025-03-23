//
//  AutocompleteCompletion.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 10/4/17.
//

import Foundation

public struct AutocompleteCompletion: Equatable {
    
    // The String to insert/replace upon autocompletion
    public let text: String
    
    // The context of the completion that you may need later when completed
    public let context: [String: Any]?
    
    public private(set) var identifier: String
        
    /// Initializes an instance with the provided text, an optional identifier, and an optional context.
    /// If no valid `identifier` is provided, a stable and unique ID is generated using a combination of `text` and `context`
    public init(text: String, identifier: String? = nil, context: [String: Any]? = nil) {
        self.text = text
        self.context = context
        self.identifier = (identifier?.isEmpty == false) ? identifier! : Self.generateID(text: text, context: context)
    }

    /// Generates a unique ID based on `text` and `context` using FNV-1a hashing.
    private static func generateID(text: String, context: [String: Any]?) -> String {
        var hash = fnv1aHash(text)
        context?.forEach { key, value in
            hash = fnvCombine(hash1: hash, hash2: fnv1aHash("\(key)=\(value)"))
        }
        return hash
    }

    /// Computes a 64-bit FNV-1a hash.
    private static func fnv1aHash(_ string: String) -> String {
        let prime: UInt64 = 1099511628211
        var hash: UInt64 = 14695981039346656037
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash &*= prime
        }
        return String(format: "%016llx", hash)
    }

    /// Merges two FNV-1a hashes.
    private static func fnvCombine(hash1: String, hash2: String) -> String {
        return fnv1aHash(hash1 + hash2)
    }
    
    public static func ==(lhs: AutocompleteCompletion, rhs: AutocompleteCompletion) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    @available(*, deprecated, message: "`displayText` should no longer be used, use `context: [String: Any]` instead")
    public init(_ text: String, displayText: String) {
        self.text = text
        self.context = nil
        self.identifier = UUID().uuidString
    }
}
