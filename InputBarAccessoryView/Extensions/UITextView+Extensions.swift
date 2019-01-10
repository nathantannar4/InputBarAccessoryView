//
//  UITextView+Extensions.swift
//  InputBarAccessoryView
//
//  Created by Ryan Nystrom on 12/22/17.
//  Modified by Nathan Tannar on 09/18/18
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

internal extension UITextView {
    
    func find(prefixes: Set<String>, with delimiterSet: CharacterSet) -> (prefix: String, word: String, range: NSRange)? {
        guard prefixes.count > 0
            else { return nil }
        
        return prefixes.compactMap({
            guard let prefix = $0.first else { return nil }
            return find(prefix: prefix, with: delimiterSet)
        }).last
    }
    
    func find(prefix: Character, with delimiterSet: CharacterSet) -> (prefix: String, word: String, range: NSRange)? {
        guard let caretRange = self.caretRange,
            let cursorRange = Range(caretRange, in: text) else { return nil }
        
        var substring = text[..<cursorRange.upperBound]
        guard let prefixIndex = substring.lastIndex(of: prefix) else { return nil }
        
        let wordRange: Range = prefixIndex..<cursorRange.upperBound
        substring = substring[wordRange]
        
        let location = wordRange.lowerBound.encodedOffset
        let length = wordRange.upperBound.encodedOffset - location
        let range = NSRange(location: location, length: length)
        
        return (String(prefix), String(substring), range)
    }
    
    func wordAtCaret(with delimiterSet: CharacterSet) -> (word: String, range: NSRange)? {
        guard let caretRange = self.caretRange,
            let result = text.word(at: caretRange, with: delimiterSet)
            else { return nil }
        
        let location = result.range.lowerBound.encodedOffset
        let range = NSRange(location: location, length: result.range.upperBound.encodedOffset - location)
        
        return (result.word, range)
    }
    
    var caretRange: NSRange? {
        guard let selectedRange = self.selectedTextRange else { return nil }
        return NSRange(
            location: offset(from: beginningOfDocument, to: selectedRange.start),
            length: offset(from: selectedRange.start, to: selectedRange.end)
        )
    }
    
}


