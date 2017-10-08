//
//  AttachmentManager.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

open class AutocompleteManager: NSObject, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    open weak var dataSource: AutocompleteManagerDataSource?
    
    open weak var delegate: AutocompleteManagerDelegate?
    
    open weak var textView: InputTextView? {
        didSet {
            textView?.delegate = self
        }
    }
    
    /// The autocomplete table for @mention or #hastag
    open lazy var tableView: AutocompleteTableView = { [weak self] in
        let tableView = AutocompleteTableView()
        tableView.register(AutocompleteCell.self, forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    /// If the autocomplete matches should be made by casting the strings to lowercase
    open var isCaseSensitive = false
    
    /// The max visible rows visible in the autocomplete table before the user has to scroll throught them
    open var maxVisibleRows = 3
    
    /// The prefices that the manager will recognize
    open var autocompletePrefixes: [Character] = ["@","#"]
    
    /// The current autocomplete text options filtered by the text after the prefix
    open var currentAutocompleteText: [String]? {
        
        guard let prefix = currentPrefix, let filter = currentFilter else { return nil }
        if filter.isEmpty {
            return autocompleteMap[prefix]
        }
        if isCaseSensitive {
            return autocompleteMap[prefix]?.filter { $0.contains( filter ) }
        }
        return autocompleteMap[prefix]?.filter { $0.lowercased().contains(filter.lowercased()) }
    }
    
    /// The default text attributes
    open var defaultTextAttributes: [NSAttributedStringKey:Any] = [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .body),
                                                                   NSAttributedStringKey.foregroundColor : UIColor.black]
    
    /// The text attributes applied to highlighted substrings for each prefix
    open var highlightedTextAttributes: [Character:[NSAttributedStringKey:Any]] = ["@":[NSAttributedStringKey.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)]]
    
    private var autocompleteMap = [Character:[String]]()
    private var currentPrefix: Character?
    private var currentPrefixRange: Range<Int>?
    private var currentFilter: String? {
        didSet {
            tableView.reloadData()
            tableView.invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
    }
    
    open func reload() {
        checkLastCharacter()
    }
    
    open func invalidate() {
        unregisterCurrentPrefix()
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAutocompleteText?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let prefix = currentPrefix, let filterText = currentFilter else { return UITableViewCell() }
        let autocompleteText = currentAutocompleteText?[indexPath.row] ?? "nil"
        let cell = dataSource?.autocompleteManager(self, tableView: tableView, cellForRowAt: indexPath, for: (prefix, filterText, autocompleteText)) ?? UITableViewCell()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let replacementText = currentAutocompleteText?[indexPath.row], let prefix = currentPrefix, let filterText = currentFilter else { return }
        if let dataSource = dataSource {
            let customReplacementText = dataSource.autocompleteManager(self, replacementTextFor: (prefix, filterText, replacementText))
            autocomplete(with: customReplacementText)
        }
        autocomplete(with: String(prefix) + replacementText)
    }

    // MARK: -  UITextViewDelegate
   
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Ensure that the text to be inserted is not using previous attributes
        resetTypingAttributes()
        
        // User deleted the registered prefix
        if let currentRange = currentPrefixRange {
            if currentRange.lowerBound >= range.lowerBound {
                unregisterCurrentPrefix()
                return true
            }
        }
        
        if let prefix = currentPrefix {
            // A prefix is already regsitered so update the filter text
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let index = newText.index(newText.startIndex, offsetBy: safeOffset(withText: newText))
            currentFilter = newText[index...]
                .components(separatedBy: " ")
                .first?
                .replacingOccurrences(of: String(prefix), with: "")
        }
        
        guard let char = text.characters.first else { return true }
        // If a space is typed or text is pasted with a space/newline unregister the current prefix
        if char == " " || char == "\n" {
            unregisterCurrentPrefix()
           
        } else if autocompletePrefixes.contains(char), let range = Range(range) {
            // Check if the first character is a registered prefix
            registerCurrentPrefix(to: char, at: range)
        }
        
        return true
    }
    
    // MARK: - Attributed Text Highlighting
    
    open func resetTypingAttributes() {
        
        var typingAttributes = [String:Any]()
        defaultTextAttributes.forEach { typingAttributes[$0.key.rawValue] = $0.value }
        textView?.typingAttributes = typingAttributes
    }
    
    // MARK: - Text Highlighting
    
    /// Finds the ranges of all substrings that start with the provided prefixes and sets those ranges background color to the InputTextView's tintColor
    ///
    /// - Parameter prefixes: The prefix the substring must begin with
//    open func highlightSubstrings(with prefixes: [Character]) {
//
//        previousPrefixCharacters = prefixes
//        let substrings = text.components(separatedBy: " ").filter {
//            var hasPrefix = false
//            for prefix in prefixes {
//                if $0.hasPrefix(String(prefix)) && $0.count > 1 {
//                    hasPrefix = true
//                    break
//                }
//            }
//            return hasPrefix
//        }
//        var ranges = [NSRange]()
//        substrings.map { return rangesOf($0, in: text) }.flatMap { return $0 }.forEach {
//            text.enumerateSubstrings(in: $0, options: .substringNotRequired) {
//                (substring, substringRange, _, _) in
//                let range = NSRange(substringRange, in: self.text)
//                ranges.append(range)
//            }
//        }
//        let attributedString = NSMutableAttributedString(string: text, attributes: defaultTextAttributes)
//        ranges.forEach { attributedString.addAttributes(highlightedTextAttributes, range: $0) }
//        attributedText = attributedString
//    }
    
    
    /// Adds the highlightedTextAttributes for the given prefix to the provided range in the textView
    ///
    /// - Parameters:
    ///   - range: The range to add attributes too
    ///   - prefix: The prefix used as the key in highlightedTextAttributes
    open func highlightSubstring(at range: NSRange, for prefix: Character) {
        
        guard let textView = textView, let attributes = highlightedTextAttributes[prefix] else { return }
        let oldAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        oldAttributedText.addAttributes(attributes, range: range)
        textView.attributedText = oldAttributedText
    }
    
    /// A helper method that returns all the ranges of a provided string in another string
    ///
    /// - Parameters:
    ///   - string: Substrings to filter the ranges
    ///   - text: The String to find ranges in
    /// - Returns: The ranges of the string in text
    private func rangesOf(_ string: String, in text: String) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()
        var searchStartIndex = text.startIndex
        
        while searchStartIndex < text.endIndex, let range = text.range(of: string, range: searchStartIndex..<text.endIndex), !range.isEmpty {
            ranges.append(range)
            searchStartIndex = range.upperBound
        }
        return ranges
    }
    
    // MARK: - Autocomplete
    
    private func registerCurrentPrefix(to prefix: Character, at range: Range<Int>) {
        
        if let delegate = delegate {
            if !delegate.autocompleteManager(self, shouldRegister: prefix, at: range) {
                return
            }
        }
        currentPrefix = prefix
        currentPrefixRange = range
        autocompleteMap[prefix] = dataSource?.autocompleteManager(self, autocompleteTextFor: prefix) ?? []
        currentFilter = String()
    }
    
    private func unregisterCurrentPrefix() {
        
        if let delegate = delegate, let prefix = currentPrefix {
            if !delegate.autocompleteManager(self, shouldUnregister: prefix) {
                return
            }
        }
        currentPrefixRange = nil
        autocompleteMap.removeAll()
        currentPrefix = nil
        currentFilter = nil
    }
    
    /// Checks the last character in the UITextView, if it matches an autocomplete prefix it is registered as the current
    private func checkLastCharacter() {
        
        guard let characters = textView?.text.characters, let char = characters.last else {
            unregisterCurrentPrefix()
            return
        }
        if autocompletePrefixes.contains(char), let range = Range(NSMakeRange(characters.count - 1, 0)) {
            registerCurrentPrefix(to: char, at: range)
        }
    }

    /// Replaces the current prefix and filter text with the supplied text
    ///
    /// - Parameters:
    ///   - text: The replacement text
    /// - Returns: If the autocomplete was successful
    @discardableResult
    public func autocomplete(with text: String) -> Bool {
        
        guard let prefix = currentPrefix, let textView = textView, let filterText = currentFilter, let prefixRange = currentPrefixRange else {
            return false
        }
        
        let textToInsert = text.appending(" ")
        if let delegate = delegate {
            if !delegate.autocompleteManager(self, shouldComplete: prefix, with: textToInsert) {
                return false
            }
        }
        // Calculate the range to replace
        let leftIndex = textView.text.index(textView.text.startIndex, offsetBy: safeOffset(withText: textView.text))
        let rightIndex = textView.text.index(textView.text.startIndex, offsetBy: safeOffset(withText: textView.text) + filterText.characters.count)
        let range = leftIndex...rightIndex
        
        // Insert the text
        textView.text.replaceSubrange(range, with: textToInsert)
        
        // Apply the highlight attributes
        highlightSubstring(at: NSMakeRange(prefixRange.lowerBound, textToInsert.count - 1), for: prefix)
        
        // Move Cursor to the end of the inserted text
        textView.selectedRange = NSMakeRange(safeOffset(withText: textView.text) + textToInsert.count, 0)
        
        // Unregister
        unregisterCurrentPrefix()
        return true
    }
    
    // MARK: - Helper Methods
    
    /// A safe way to generate an offset to the current prefix
    ///
    /// - Returns: An offset that is not more than the endIndex or less than the startIndex
    private func safeOffset(withText text: String) -> Int {
        
        guard let range = currentPrefixRange else { return 0 }
        if text.characters.count == 0 {
            return 0
        }
        if range.lowerBound > (text.characters.count - 1) {
            return text.characters.count - 1
        }
        if range.lowerBound < 0 {
            return 0
        }
        return range.lowerBound
    }
    
    // MARK: - Default Autocomplete Cell
    
    open func defaultCell(in tableView: UITableView, at indexPath: IndexPath, for arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("AutocompleteCell is not registered")
        }
        
        let matchingRange = (arguments.autocompleteText as NSString).range(of: arguments.filterText, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(arguments.autocompleteText)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)], range: matchingRange)
        let stringWithPrefix = NSMutableAttributedString().normal(String(arguments.prefix))
        stringWithPrefix.append(attributedString)
        cell.textLabel?.attributedText = stringWithPrefix
        
        cell.backgroundColor = .white
        cell.tintColor = textView?.tintColor ?? UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        cell.separatorLine.isHidden = indexPath.row == (currentAutocompleteText ?? []).count - 1
        
        return cell
    }
}
