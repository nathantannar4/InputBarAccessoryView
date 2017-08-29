//
//  InputTextView.swift
//  InputBarAccessoryView
//
//  Copyright © 2017 Nathan Tannar.
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
//  Created by Nathan Tannar on 8/18/17.
//

import Foundation
import UIKit

open class InputTextView: UITextView, UITextViewDelegate {
    
    // MARK: - Properties
    
    open weak var autocompleteDelegate: InputTextViewAutocompleteDelegate?
    
    open var autocompletePrefixes: [Character] = ["@", "#"] {
        didSet {
            checkForTypedPrefixes()
        }
    }
    
    open override var text: String! {
        didSet {
            textViewTextDidChange()
        }
    }

    open let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Aa"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var placeholderLabelConstraintSet: NSLayoutConstraintSet?
    
    open var placeholder: String? = "Aa" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    
    override open var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    public weak var inputBarAccessoryView: InputBarAccessoryView?
    
    private var currentPrefix: Character?
    private var currentPrefixRange: Range<Int>?
    
    // MARK: - Initializers
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func setup() {
        
        font = UIFont.preferredFont(forTextStyle: .body)
        isScrollEnabled = false
        delegate = self
        addSubviews()
        addObservers()
        addConstraints()
    }
    
    private func addSubviews() {
        
        addSubview(placeholderLabel)
    }
    
    private func addConstraints() {
        
        placeholderLabelConstraintSet = NSLayoutConstraintSet(
            top:    placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            bottom: placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom),
            left:   placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeholderLabelInsets.left),
            right:  placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -placeholderLabelInsets.right)
        ).activate()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        
        placeholderLabelConstraintSet?.top?.constant = placeholderLabelInsets.top
        placeholderLabelConstraintSet?.bottom?.constant = -placeholderLabelInsets.bottom
        placeholderLabelConstraintSet?.left?.constant = placeholderLabelInsets.left
        placeholderLabelConstraintSet?.right?.constant = -placeholderLabelInsets.right
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputTextView.textViewTextDidChange),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: nil)
    }
    
    // MARK: - Notifications
    
    open func textViewTextDidChange() {
        
        placeholderLabel.isHidden = !text.isEmpty
        checkForTypedPrefixes()
    }
    
    // MARK: -  UITextViewDelegate
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let char = text.characters.first else { return true }
        if autocompletePrefixes.contains(char) {
            currentPrefix = char
            currentPrefixRange = range.toRange()
        }
        if char == " " {
            currentPrefix = nil
            currentPrefixRange = nil
        }
        
        return true
    }
    
    // MARK: - Autocomplete
    
    /// Checks the last character for registered prefixes
    open func checkForTypedPrefixes() {
        
        if let prefix = currentPrefix, let prefixRange = currentPrefixRange {
            var offset = prefixRange.lowerBound
            if offset > (text.characters.count - 1) {
                offset = text.characters.count - 1
            }
            if offset < 0 {
                offset = 0
            }
            
            let index = text.index(text.startIndex, offsetBy: offset)
            if let filerText = text.substring(from: index)
                .components(separatedBy:  " ")
                .first?
                .replacingOccurrences(of: String(prefix), with: "") {
                
                autocompleteDelegate?.inputTextView(self, didTypeAutocompletePrefix: prefix, withText: filerText)
            }
        }
    }
    
    /// Completes a prefix by replacing the string after the prefix with the provided text
    ///
    /// - Parameters:
    ///   - prefix: The prefix
    ///   - index: The index of the prefix
    ///   - text: The text to autocomplete to
    /// - Returns: If the autocomplete was successful
    @discardableResult
    open func autocomplete(withText autocompleteText: String, from enteredText: String) -> Bool {
        
        guard let prefix = currentPrefix, let prefixRange = currentPrefixRange else {
            return false
        }
        
        var offset = prefixRange.lowerBound
        if offset > (text.characters.count - 1) {
            offset = text.characters.count - 1
        }
        if offset < 0 {
            offset = 0
        }

        let leftIndex = text.index(text.startIndex, offsetBy: offset)
        let leftText = text.substring(to: leftIndex)
        
        let rightIndex = text.index(text.startIndex, offsetBy: offset + enteredText.characters.count + 1)
        let rightText = text.substring(from: rightIndex)
        
        self.text = leftText + String(prefix) + autocompleteText + rightText
        currentPrefix = nil
        currentPrefixRange = nil
        return true
    }
}
