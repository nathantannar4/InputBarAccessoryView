//
//  InputBarAccessoryView+Availability.swift
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
//  Created by Nathan Tannar on 2/12/17.
//

import UIKit

@available(*, deprecated, message: "InputManager has been renamed to InputPlugin")
public typealias InputManager = InputPlugin

extension InputPlugin {
    
    @available(*, deprecated, message: "`handleInput(object:)` should return a `Bool` if handle was successful or now")
    func handleInput(of object: AnyObject) {
        _ = self.handleInput(of: object)
    }
}

extension AutocompleteCompletion {
    
    // An optional string to display instead of `text`, for example emojis
    @available(*, deprecated, message: "`displayText` should no longer be used, use `context: [String: Any]` instead")
    public var displayText: String? {
        return text
    }
}

extension AutocompleteManager {
    /// If the autocomplete matches should be made by casting the strings to lowercase.
    /// Default value is `FALSE`
    /// DEPRICATED; will always return `FALSE`
    @available(*, deprecated, message: "`isCaseSensitive` was replaced in favour of a more customizable `filterBlock: (String) -> (Bool)`")
    public var isCaseSensitive: Bool {
        get { return false }
        set {
            if newValue {
                filterBlock = { session, completion in
                    completion.text.contains(session.filter)
                }
            } else {
                filterBlock = { session, completion in
                    completion.text.lowercased().contains(session.filter.lowercased())
                }
            }
        }
    }
}

extension InputBarAccessoryView {

    /**
     The anchor constants used by the InputStackView

     ````
     V:|...-(padding.top)-(textViewPadding.top)-[InputTextView]-(textViewPadding.bottom)-[InputStackView.bottom]-...|

     H:|...-[InputStackView.left]-(textViewPadding.left)-[InputTextView]-(textViewPadding.right)-[InputStackView.right]-...|
     ````

     */
    @available(*, deprecated, message: "The `InputTextView` now resides in the `middleContentView` and thus this property has been renamed to `middleContentViewPadding`")
    public var textViewPadding: UIEdgeInsets {
        get {
            return middleContentViewPadding
        }
        set {
            middleContentViewPadding = newValue
        }
    }
}
