//
//  AttachmentManager.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2018 Nathan Tannar.
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

public struct AutocompleteCompletion {
    
    // The string used for sorting and to autocomplete a prefix
    var text: String
    
    // An optional string to display instead of `text`, for example emojis
    var displayText: String?
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ text: String, displayText: String) {
        self.text = text
        self.displayText = displayText
    }
}

/// A structure containing data on the `AutocompleteManager`'s session
public struct AutocompleteSession {
    
    let prefix: String
    var range: NSRange
    var filter: String
    var completion: AutocompleteCompletion?
    
    public init?(prefix: String?, range: NSRange?, filter: String?) {
        guard let pfx = prefix, let rng = range, let flt = filter else { return nil }
        self.prefix = pfx
        self.range = rng
        self.filter = flt
    }
}

open class AutocompleteManager: NSObject, InputManager {
    
    // MARK: - Properties [Public]
    
    /// A protocol that passes data to the `AutocompleteManager`
    open weak var dataSource: AutocompleteManagerDataSource?
    
    /// A protocol that more precisely defines `AutocompleteManager` logic
    open weak var delegate: AutocompleteManagerDelegate?
    
    /// A reference to the `InputTextView` that the `AutocompleteManager` is using
    private(set) public weak var inputTextView: InputTextView?
    
    /// An ongoing session reference that holds the prefix, range and text to complete with
    private(set) public var currentSession: AutocompleteSession? { didSet { layoutIfNeeded() } }
    
    /// The `AutocompleteTableView` that renders available autocompletes for the `currentSession`
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
    
    /// If the autocomplete matches should be made by casting the strings to lowercase.
    /// Default value is `FALSE`
    open var isCaseSensitive = false
    
    /// Adds an additional space after the autocompleted text when true.
    /// Default value is `TRUE`
    open var appendSpaceOnCompletion = true
    
    /// Keeps the prefix typed when text is autocompleted.
    /// Default value is `TRUE`
    open var keepPrefixOnCompletion = true
    
    /// The default text attributes
    open var defaultTextAttributes: [NSAttributedStringKey: Any] =
        [.font: UIFont.preferredFont(forTextStyle: .body), .foregroundColor: UIColor.black]
    
    // MARK: - Properties [Private]
    
    /// The prefices that the manager will recognize
    private var autocompletePrefixes = Set<String>()
    
    /// The text attributes applied to highlighted substrings for each prefix
    private var autocompleteTextAttributes = [String: [NSAttributedStringKey: Any]]()
    
    /// A key used for referencing which substrings were autocompletes
    private let NSAttributedAutocompleteKey = NSAttributedStringKey.init("com.messagekit.autocompletekey")
    
    /// A reference to `defaultTextAttributes` that adds the NSAttributedAutocompleteKey
    private var typingTextAttributes: [NSAttributedStringKey: Any] {
        var attributes = defaultTextAttributes
        attributes[NSAttributedAutocompleteKey] = false
        return attributes
    }
    
    /// The current autocomplete text options filtered by the text after the prefix
    private var currentAutocompleteOptions: [AutocompleteCompletion] {
        
        guard let session = currentSession, let completions = dataSource?.autocompleteManager(self, autocompleteSourceFor: session.prefix) else { return [] }
        guard !session.filter.isEmpty else { return completions }
        guard isCaseSensitive else { return completions.filter { $0.text.lowercased().contains(session.filter.lowercased()) } }
        return completions.filter { $0.text.contains(session.filter) }
    }
    
    // MARK: - Initialization
    
    public init(for textView: InputTextView) {
        super.init()
        self.inputTextView = textView
        self.inputTextView?.delegate = self
    }
    
    // MARK: - InputManager
    
    /// Reloads the InputManager's session
    open func reloadData() {

        guard let result = inputTextView?.find(prefixes: autocompletePrefixes) else {
            invalidate()
            return
        }
        let wordWithoutPrefix = (result.word as NSString).substring(from: result.prefix.utf16.count)
        guard let session = AutocompleteSession(prefix: result.prefix, range: result.range, filter: wordWithoutPrefix) else { return }
        registerCurrentSession(to: session)
    }
    
    /// Invalidates the InputManager's session
    open func invalidate() {
        unregisterCurrentSession()
    }
    
    /// Passes an object into the InputManager's session to handle
    ///
    /// - Parameter object: A string to append
    open func handleInput(of object: AnyObject) {
        guard let newText = object as? String, let textView = inputTextView else { return }
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let newAttributedString = NSAttributedString(string: newText, attributes: typingTextAttributes)
        attributedString.append(newAttributedString)
        textView.attributedText = attributedString
        reloadData()
    }
    
    // MARK: - API [Public]
    
    open func register(prefix: String, with attributedTextAttributes: [NSAttributedStringKey:Any]? = nil) {
        autocompletePrefixes.insert(prefix)
        autocompleteTextAttributes[prefix] = attributedTextAttributes
    }
    
    open func unregister(prefix: String) {
        autocompletePrefixes.remove(prefix)
        autocompleteTextAttributes[prefix] = nil
    }
    
    /// Replaces the current prefix and filter text with the supplied text
    ///
    /// - Parameters:
    ///   - text: The replacement text
    open func autocomplete(with session: AutocompleteSession) {
        
        guard let textView = inputTextView else { return }
        guard delegate?.autocompleteManager(self, shouldComplete: session.prefix, with: session.filter) != false else { return }
        
        // Create a range that overlaps the prefix
        let prefixLength = session.prefix.utf16.count
        let insertionRange = NSRange(
            location: session.range.location + (keepPrefixOnCompletion ? prefixLength : 0),
            length: session.filter.utf16.count + (!keepPrefixOnCompletion ? prefixLength : 0)
        )
        
        // Transform range
        guard let range = Range(insertionRange, in: textView.text) else { return }
        let nsrange = NSRange(range, in: textView.text)
        
        // Replace the attributedText with a modified version
        let autocomplete = session.completion?.text ?? ""
        insertAutocomplete(autocomplete, at: session, for: nsrange)
        
        // Move Cursor to the end of the inserted text
        let selectedLocation = insertionRange.location + autocomplete.utf16.count + (appendSpaceOnCompletion ? 1 : 0)
        textView.selectedRange = NSRange(
            location: selectedLocation,
            length: 0
        )
        
        // End the session
        unregisterCurrentSession()
    }
    
    // MARK: - API [Private]
    
    /// Resets the `InputTextView`'s typingAttributes to `defaultTextAttributes`
    private func preserveTypingAttributes() {
        
        var typingAttributes = [String: Any]()
        typingTextAttributes.forEach { typingAttributes[$0.key.rawValue] = $0.value }
        inputTextView?.typingAttributes = typingAttributes
    }
    
    
    /// Inserts an autocomplete for a given selection
    ///
    /// - Parameters:
    ///   - autocomplete: The 'String' to autocomplete to
    ///   - sesstion: The 'AutocompleteSession'
    ///   - range: The 'NSRange' to insert over
    private func insertAutocomplete(_ autocomplete: String, at session: AutocompleteSession, for range: NSRange) {
        
        guard let textView = inputTextView else { return }
        
        // Apply the autocomplete attributes
        var attrs = autocompleteTextAttributes[session.prefix] ?? defaultTextAttributes
        attrs[NSAttributedAutocompleteKey] = true
        let newString = (keepPrefixOnCompletion ? session.prefix : "") + autocomplete
        let newAttributedString = NSAttributedString(string: newString, attributes: attrs)
        
        // Modify the NSRange to include the prefix length
        let rangeModifier = keepPrefixOnCompletion ? session.prefix.count : 0
        let highlightedRange = NSRange(location: range.location - rangeModifier, length: range.length + rangeModifier)
        
        // Replace the attributedText with a modified version including the autocompete
        let newAttributedText = textView.attributedText.replacingCharacters(in: highlightedRange, with: newAttributedString)
        if appendSpaceOnCompletion {
            newAttributedText.append(NSAttributedString(string: " ", attributes: typingTextAttributes))
        }
        textView.attributedText = newAttributedText
    }
    
    /// Initializes a session with a new `AutocompleteSession` object
    ///
    /// - Parameters:
    ///   - session: The session to register
    private func registerCurrentSession(to session: AutocompleteSession) {
        
        guard delegate?.autocompleteManager(self, shouldRegister: session.prefix, at: session.range) != false else { return }
        currentSession = session
        delegate?.autocompleteManager(self, shouldBecomeVisible: true)
    }
    
    /// Invalidates the `currentSession` session if it existed
    private func unregisterCurrentSession() {
        
        guard let session = currentSession else { return }
        guard delegate?.autocompleteManager(self, shouldUnregister: session.prefix) != false else { return }
        currentSession = nil
        delegate?.autocompleteManager(self, shouldBecomeVisible: false)
    }
    
    /// Calls the required methods to relayout the `AutocompleteTableView` in it's superview
    private func layoutIfNeeded() {
        
        tableView.reloadData()
        
        // Resize the table to be fit properly in an `InputStackView`
        tableView.invalidateIntrinsicContentSize()
        
        // Layout the table's superview
        tableView.superview?.layoutIfNeeded()
    }
    
}

extension AutocompleteManager: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    
    public func textViewDidChange(_ textView: UITextView) {
        reloadData()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Ensure that the text to be inserted is not using previous attributes
        preserveTypingAttributes()
        
        // range.length > 0: Backspace/removing text
        // range.lowerBound < textView.selectedRange.lowerBound: Ignore trying to delete
        //      the substring if the user is already doing so
        if range.length > 0, range.lowerBound < textView.selectedRange.lowerBound {
            
            // Backspace/removing text
            let attribute = textView.attributedText
                .attributes(at: range.lowerBound, longestEffectiveRange: nil, in: range)
                .filter { return $0.key == NSAttributedAutocompleteKey }
            
            if (attribute[NSAttributedAutocompleteKey] as? Bool ?? false) == true {
                
                // Remove the autocompleted substring
                let lowerRange = NSRange(location: 0, length: range.location + 1)
                textView.attributedText.enumerateAttribute(NSAttributedAutocompleteKey, in: lowerRange, options: .reverse, using: { (_, range, stop) in
                    
                    // Only delete the first found range
                    defer { stop.pointee = true }
                    
                    let emptyString = NSAttributedString(string: "", attributes: typingTextAttributes)
                    textView.attributedText = textView.attributedText.replacingCharacters(in: range, with: emptyString)
                    textView.selectedRange = NSRange(location: range.location, length: 0)
                })
                unregisterCurrentSession()
                return false
            }
        }
        return true
    }
    
}

extension AutocompleteManager: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAutocompleteOptions.count
    }
    
    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var session = currentSession else { return UITableViewCell() }
        session.completion = currentAutocompleteOptions[indexPath.row]
        let cell = dataSource?.autocompleteManager(self, tableView: tableView, cellForRowAt: indexPath, for: session) ?? UITableViewCell()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    final public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard var session = currentSession else { return }
        session.completion = currentAutocompleteOptions[indexPath.row]
        autocomplete(with: session)
    }
    
}
