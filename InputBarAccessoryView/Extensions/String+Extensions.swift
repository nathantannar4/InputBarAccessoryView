//
//  String+Extensions.swift
//  InputBarAccessoryView
//
//  Created by Ryan Nystrom on 12/22/17.
//  Modified by Nathan Tannar on 09/18/18
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

internal extension String {
    
    func wordParts(_ range: Range<String.Index>, _ delimiterSet: CharacterSet) -> (left: String.SubSequence, right: String.SubSequence)? {
        let leftView = self[..<range.upperBound]
        let leftIndex = leftView.rangeOfCharacter(from: delimiterSet, options: .backwards)?.upperBound
            ?? leftView.startIndex
        
        let rightView = self[range.upperBound...]
        let rightIndex = rightView.rangeOfCharacter(from: delimiterSet)?.lowerBound
            ?? endIndex
        
        return (leftView[leftIndex...], rightView[..<rightIndex])
    }

    func word(at nsrange: NSRange, with delimiterSet: CharacterSet) -> (word: String, range: Range<String.Index>)? {
        guard !isEmpty,
            let range = Range(nsrange, in: self),
            let parts = self.wordParts(range, delimiterSet)
            else { return nil }

        // if the left-next character is in the delimiterSet, the "right word part" is the full word
        // short circuit with the right word part + its range
        if let characterBeforeRange = index(range.lowerBound, offsetBy: -1, limitedBy: startIndex),
            let character = self[characterBeforeRange].unicodeScalars.first,
            delimiterSet.contains(character) {
            let right = parts.right
            let word = String(right)
            return (word, right.startIndex ..< right.endIndex)
        }
        
        let joinedWord = String(parts.left + parts.right)
        guard !joinedWord.isEmpty else { return nil }
        return (joinedWord, parts.left.startIndex ..< parts.right.endIndex)
    }
}

extension Character {
    
    static var space: Character {
        return " "
    }
}
