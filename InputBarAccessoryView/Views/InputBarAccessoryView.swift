//
//  InputBarAccessoryView.swift
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

open class InputBarAccessoryView: UIView {
    
    public enum UIStackViewPosition {
        case left, right, bottom
    }
    
    // MARK: - Properties
    
    open weak var delegate: InputBarAccessoryViewDelegate?
    open weak var dataSource: InputBarAccessoryViewDataSource?
    
    /// A background view that adds a blur effect. Shown when 'isTransparent' is set to TRUE. Hidden by default.
    open lazy var backgroundView: UIView = { [weak self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    /// When set to true, the blurView in the background is shown and the backgroundColor is set to .clear. Default is FALSE
    open var isTranslucent: Bool = false {
        didSet {
            blurView.isHidden = !isTranslucent
            backgroundView.backgroundColor = isTranslucent ? .clear : .white
        }
    }

    /// A boarder line anchored to the top of the view
    open let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    open let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    open let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    open lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: InputTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    open lazy var textView: InputTextView = { [weak self] in
        let textView = InputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.inputBarAccessoryView = self
        textView.autocompleteDelegate = self
        return textView
    }()
    
    /// The padding around the textView that separates it from the stackViews
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
            textViewLayoutSet?.left?.constant = textViewPadding.left
            textViewLayoutSet?.right?.constant = -textViewPadding.right
            bottomStackViewLayoutSet?.top?.constant = textViewPadding.bottom
        }
    }
    
    open var sendButton: InputBarButtonItem = {
        return InputBarButtonItem()
            .configure {
                $0.size = CGSize(width: 52, height: 36)
                $0.isEnabled = false
                $0.title = "Send"
                $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            }.onTextViewDidChange({ (item, textView) in
                item.isEnabled = !textView.text.isEmpty
            }).onTouchUpInside {
                $0.inputBarAccessoryView?.didSelectSendButton()
        }
    }()
    
    /// The anchor contants used by the UIStackViews and InputTextView to create padding within the InputBarAccessoryView
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12) {
        didSet {
            updateViewContraints()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let sizeToFit = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude))
        var heightToFit = sizeToFit.height.rounded() + padding.top + padding.bottom + separatorLine.frame.height + tableViewHeightConstant
        if heightToFit >= maxHeight {
            textView.isScrollEnabled = true
            heightToFit = maxHeight
        } else {
            textView.isScrollEnabled = false
        }
        let size = CGSize(width: bounds.width, height: heightToFit)
        if previousIntrinsicContentSize != size {
            delegate?.inputBar(self, didChangeIntrinsicContentTo: size)
        }
        previousIntrinsicContentSize = size
        return size
    }
    
    /// The maximum intrinsicContentSize height. When reached the delegate 'didChangeIntrinsicContentTo' will be called.
    open var maxHeight: CGFloat = UIScreen.main.bounds.height / 3 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The fixed widthAnchor constant of the leftStackView
    private(set) var leftStackViewWidthConstant: CGFloat = 0 {
        didSet {
            leftStackViewLayoutSet?.width?.constant = leftStackViewWidthConstant
        }
    }
    
    /// The fixed widthAnchor constant of the rightStackView
    private(set) var rightStackViewWidthConstant: CGFloat = 52 {
        didSet {
            rightStackViewLayoutSet?.width?.constant = rightStackViewWidthConstant
        }
    }
    
    private(set) var tableViewHeightConstant: CGFloat = .leastNonzeroMagnitude {
        didSet {
            tableViewHeightConstraint?.constant = tableViewHeightConstant
        }
    }
    
    internal var currentPrefix: Character?
    internal var currentAutocompleteFilter: String?
    
    /// When set to TRUE and the swipe gesture direction on the InputTextView is down the first responder will be resigned
    open var shouldDismissOnSwipe: Bool = true

    /// The InputBarItems held in the leftStackView
    private(set) var leftStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the rightStackView
    private(set) var rightStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the bottomStackView
    private(set) var bottomStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputBarButtonItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputBarButtonItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, nonStackViewItems].flatMap { $0 }
    }

    // MARK: - Auto-Layout Management
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var leftStackViewLayoutSet: NSLayoutConstraintSet?
    private var rightStackViewLayoutSet: NSLayoutConstraintSet?
    private var bottomStackViewLayoutSet: NSLayoutConstraintSet?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var previousIntrinsicContentSize: CGSize?
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    open func setup() {
        
        tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        backgroundColor = .clear
        autoresizingMask = .flexibleHeight
        setupSubviews()
        setupConstraints()
        setupObservers()
        setupGestureRecognizers()
    }
    
    private func setupSubviews() {
        
        addSubview(backgroundView)
        backgroundView.addSubview(blurView)
        addSubview(textView)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(bottomStackView)
        addSubview(tableView)
        addSubview(separatorLine)
        setStackViewItems([sendButton], forStack: .right, animated: false)
    }
    
    private func setupConstraints() {
        
        tableViewHeightConstraint = tableView.addConstraints(topAnchor, left: leftAnchor, right: rightAnchor, heightConstant: .leastNonzeroMagnitude).last
        separatorLine.addConstraints(tableView.bottomAnchor, left: leftAnchor, right: rightAnchor, heightConstant: 0.5)
        backgroundView.addConstraints(tableView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        blurView.fillSuperview()
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    textView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: padding.top),
            bottom: textView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -textViewPadding.bottom),
            left:   textView.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: textViewPadding.left),
            right:  textView.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -textViewPadding.right)
        ).activate()
        textViewLayoutSet?.height = textView.heightAnchor.constraint(equalToConstant: 36)
        
        leftStackViewLayoutSet = NSLayoutConstraintSet(
            top:    textView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: padding.top),
            bottom: leftStackView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            left:   leftStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            width:  leftStackView.widthAnchor.constraint(equalToConstant: leftStackViewWidthConstant)
        ).activate()
        
        rightStackViewLayoutSet = NSLayoutConstraintSet(
            top:    textView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: padding.top),
            bottom: rightStackView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            right:  rightStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            width:  rightStackView.widthAnchor.constraint(equalToConstant: rightStackViewWidthConstant)
        ).activate()

        bottomStackViewLayoutSet = NSLayoutConstraintSet(
            top:    bottomStackView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            bottom: bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   bottomStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  bottomStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right)
        ).activate()
    }
    
    private func updateViewContraints() {
        
        textViewLayoutSet?.top?.constant = padding.top
        leftStackViewLayoutSet?.top?.constant = padding.top
        leftStackViewLayoutSet?.left?.constant = padding.left
        rightStackViewLayoutSet?.top?.constant = padding.top
        rightStackViewLayoutSet?.right?.constant = -padding.right
        bottomStackViewLayoutSet?.left?.constant = padding.left
        bottomStackViewLayoutSet?.right?.constant = -padding.right
        bottomStackViewLayoutSet?.bottom?.constant = -padding.bottom
    }
    
    private func setupObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.orientationDidChange),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.textViewDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.textViewDidBeginEditing),
                                               name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarAccessoryView.textViewDidEndEditing),
                                               name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    private func setupGestureRecognizers() {
        
        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(InputBarAccessoryView.didSwipeTextView(_:)))
            gesture.direction = direction
            textView.addGestureRecognizer(gesture)
        }
    }
    
    // MARK: - Layout Helper Methods
    
    /// Called during the hooks so account for any size changes
    private func layoutStackViews() {
        
        for stackView in [leftStackView, rightStackView, bottomStackView] {
            stackView.setNeedsLayout()
            stackView.layoutIfNeeded()
        }
    }
    
    /// Performs layout changes over the main thread
    ///
    /// - Parameters:
    ///   - animated: If the layout should be animated
    ///   - animations: Code
    private func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
    }
    
    // MARK: - UIStackView InputBarItem Methods
    
    /// Removes all of the arranged subviews from the UIStackView and adds the given items. Sets the inputBarAccessoryView property of the InputBarButtonItem
    ///
    /// - Parameters:
    ///   - items: New UIStackView arranged views
    ///   - position: The targeted UIStackView
    ///   - animated: If the layout should be animated
    open func setStackViewItems(_ items: [InputBarButtonItem], forStack position: UIStackViewPosition, animated: Bool) {
        
        func setNewItems() {
            switch position {
            case .left:
                leftStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                leftStackViewItems = items
                leftStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    leftStackView.addArrangedSubview($0)
                }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    rightStackView.addArrangedSubview($0)
                }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    bottomStackView.addArrangedSubview($0)
                }
                bottomStackView.layoutIfNeeded()
            }
        }
        
        performLayout(animated) {
            setNewItems()
        }
    }
    
    /// Sets the leftStackViewWidthConstant
    ///
    /// - Parameters:
    ///   - newValue: New widthAnchor constant
    ///   - animated: If the layout should be animated
    open func setLeftStackViewWidthConstant(to newValue: CGFloat, animated: Bool) {
        performLayout(animated) { 
            self.leftStackViewWidthConstant = newValue
        }
    }
    
    /// Sets the rightStackViewWidthConstant
    ///
    /// - Parameters:
    ///   - newValue: New widthAnchor constant
    ///   - animated: If the layout should be animated
    open func setRightStackViewWidthConstant(to newValue: CGFloat, animated: Bool) {
        performLayout(animated) { 
            self.rightStackViewWidthConstant = newValue
        }
    }
    
    
    /// Sets the tableViewHeighConstant. This should only be used if you start overriding the UITableViewDatasource methods.
    ///
    /// - Parameters:
    ///   - newValue: New heightAnchor constant
    ///   - animated: If the layout should be animated
    open func setTableViewHeightConstant(to newValue: CGFloat) {
        performLayout(false) {
            self.tableViewHeightConstraint?.constant = newValue
        }
    }
    
    // MARK: - Notifications/Hooks
    
    open func orientationDidChange() {
        invalidateIntrinsicContentSize()
    }
    
    open func textViewDidChange() {
        textViewLayoutSet?.height?.isActive = textView.text.isEmpty
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        performLayout(true) { 
            self.items.forEach { $0.textViewDidChangeAction(with: self.textView) }
            self.layoutStackViews()
        }
        delegate?.inputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    open func textViewDidBeginEditing() {
        performLayout(true) { 
            self.items.forEach { $0.keyboardEditingBeginsAction() }
            self.layoutStackViews()
        }
    }
    
    open func textViewDidEndEditing() {
        performLayout(true) { 
            self.items.forEach { $0.keyboardEditingEndsAction() }
            self.layoutStackViews()
        }
    }
    
    // MARK: - User Actions
    
    open func didSwipeTextView(_ gesture: UISwipeGestureRecognizer) {
        
        performLayout(true) { 
            self.items.forEach { $0.keyboardSwipeGestureAction(with: gesture) }
            self.layoutStackViews()
        }
        delegate?.inputBar(self, didSwipeTextViewWith: gesture)
        
        if shouldDismissOnSwipe && gesture.direction == .down {
            resignFirstResponder()
        }
    }
    
    open func didSelectSendButton() {
        delegate?.inputBar(self, didPressSendButtonWith: textView.text)
        textViewDidChange()
    }
    
    open func didSelectInputBarItem(_ item: InputBarButtonItem) {
        items.forEach { $0.isSelected = false }
        item.touchUpInsideAction()
    }
}

// MARK: - InputTextViewDelegate

extension InputBarAccessoryView: InputTextViewAutocompleteDelegate {
    
    open func inputTextView(_ textView: InputTextView, didTypeAutocompletePrefix prefix: Character, withText text: String) {
        currentPrefix = prefix
        currentAutocompleteFilter = text
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension InputBarAccessoryView: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let prefix = currentPrefix, let filterText = currentAutocompleteFilter, let dataSource = dataSource else {
            return 0
        }
        let numberOfRows = dataSource.inputBar(self, autocompleteOptionsForPrefix: prefix, withEnteredText: filterText).count
        let multiplier = numberOfRows < 4 ? CGFloat(numberOfRows) : 3
        let tableViewHeight = multiplier * tableView.rowHeight
        setTableViewHeightConstant(to: tableViewHeight)
        return numberOfRows
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = dataSource?.inputBar(self, tableView: tableView, cellForRowAt: indexPath), let prefix = currentPrefix, let filterText = currentAutocompleteFilter else {
            return UITableViewCell()
        }
        cell.prefix = prefix
        cell.autocompleteText = dataSource?.inputBar(self, autocompleteOptionsForPrefix: prefix, withEnteredText: filterText)[indexPath.row]
        cell.tintColor = tintColor
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InputBarAccessoryView: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let prefix = currentPrefix, let filterText = currentAutocompleteFilter, let dataSource = dataSource else {
            return
        }
        let replacementText = dataSource.inputBar(self, autocompleteOptionsForPrefix: prefix, withEnteredText: filterText)[indexPath.row]
        if textView.autocomplete(withText: replacementText, from: filterText) {
            setTableViewHeightConstant(to: 0)
        }
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        tableView.bounces = !(indexPath.row == lastRow)
    }
}
