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
        guard prefixes.count > 0,
            let result = wordAtCaret(with: delimiterSet),
            !result.word.isEmpty
            else { return nil }
        for prefix in prefixes {
            if result.word.hasPrefix(prefix) {
                return (prefix, result.word, result.range)
            }
        }
        return nil
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


