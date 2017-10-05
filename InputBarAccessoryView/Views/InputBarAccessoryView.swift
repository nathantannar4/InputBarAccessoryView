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

open class SeparatorLine: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 0.5)
    }
}

open class InputBarAccessoryView: UIView {
    
    public enum UIStackViewPosition {
        case left, right, bottom, top
    }
    
    // MARK: - Properties
    
    open weak var delegate: InputBarAccessoryViewDelegate?
    
    open var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    /// A backgroundView subview that adds a blur effect. Shown when 'isTransparent' is set to TRUE. Hidden by default.
    open var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// When set to true, the blurView in the background is shown and the backgroundColor is set to .clear. Default is FALSE
    open var isTranslucent: Bool = false {
        didSet {
            if isTranslucent {
                blurView.isHidden = false
                if blurView.superview == nil {
                    backgroundView.addSubview(blurView)
                    blurView.fillSuperview()
                }
            } else if !isTranslucent {
                blurView.isHidden = true
            }
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
    
    open let topStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    /// The object that manages attachments
    open var attachmentManager = AttachmentManager() {
        willSet {
            // Ensures old view is removed
            isAttachmentViewHidden = true
        }
        didSet {
            isAttachmentViewHidden = false
        }
    }
    
    /// When set to TRUE the AttachmentsView corresponding to the AttachmentManager will be added to the top UIStackView
    open var isAttachmentViewHidden: Bool = true {
        didSet {
            if !isAttachmentViewHidden && attachmentManager.attachmentView.superview == nil {
                topStackView.addArrangedSubview(attachmentManager.attachmentView)
                attachmentManager.inputBarAccessoryView = self
            } else if isAttachmentViewHidden {
                attachmentManager.attachmentView.removeFromSuperview()
                attachmentManager.inputBarAccessoryView = nil
            }
        }
    }
    
    /// The object that manages autocomplete. When set isAutocompleteEnabled is automatically set to TRUE
    open var autocompleteManager = AutocompleteManager() {
        willSet {
            // Ensures old view is removed
            isAutocompleteEnabled = false
        }
        didSet {
            isAutocompleteEnabled = true
        }
    }
    
    /// When set to TRUE the UITableView corresponding to the AutocompleteManager will be added to the top UIStackView
    open var isAutocompleteEnabled: Bool = false {
        didSet {
            if isAutocompleteEnabled && autocompleteManager.tableView.superview == nil {
                topStackView.insertArrangedSubview(autocompleteManager.tableView, at: 0)
                textView.delegate = autocompleteManager
                autocompleteManager.inputBarAccessoryView = self
            } else if !isAutocompleteEnabled {
                autocompleteManager.tableView.removeFromSuperview()
                autocompleteManager.inputBarAccessoryView = nil
            }
        }
    }
    
    open lazy var textView: InputTextView = { [weak self] in
        let textView = InputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.inputBarAccessoryView = self
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
                $0.setSize(CGSize(width: 52, height: 36), animated: false)
                $0.isEnabled = false
                $0.title = "Send"
                $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            }.onTouchUpInside {
                $0.inputBarAccessoryView?.didSelectSendButton()
        }
    }()
    
    /// The anchor contants used by the UIStackViews and InputTextView to create padding within the InputBarAccessoryView
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12) {
        didSet {
            updatePadding()
        }
    }
    
    /// The padding around the top UIStackView that separates it from the separator line and its superview
    open var topStackViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            separatorLineTopConstraint?.constant = topStackViewPadding.bottom
            topStackViewLayoutSet?.top?.constant = topStackViewPadding.top
            topStackViewLayoutSet?.left?.constant = topStackViewPadding.left
            topStackViewLayoutSet?.right?.constant = -topStackViewPadding.right
            invalidateIntrinsicContentSize()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        
        let maxTextViewSize = CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)
        var heightToFit = textView.sizeThatFits(maxTextViewSize).height.rounded()
        
        if heightToFit >= maxTextViewHeight {
            if !isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = true
                textView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            heightToFit = maxTextViewHeight
        } else {
            if isOverMaxTextViewHeight {
                textViewHeightAnchor?.isActive = false
                textView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
            }
            textView.invalidateIntrinsicContentSize()
        }
        let size = CGSize(width: bounds.width, height: heightToFit)
        
        if previousIntrinsicContentSize != size {
            delegate?.inputBar(self, didChangeIntrinsicContentTo: size)
        }
        previousIntrinsicContentSize = size
        return size
    }
    
    private(set) var isOverMaxTextViewHeight = false
    
    /// The maximum height of content not including the topStackView. When reached the delegate 'didChangeIntrinsicContentTo' will be called.
    open var maxTextViewHeight: CGFloat = (UIScreen.main.bounds.height / 3).rounded() {
        didSet {
            textViewHeightAnchor?.constant = maxTextViewHeight
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

    /// The InputBarItems held in the leftStackView
    private(set) var leftStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the rightStackView
    private(set) var rightStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the bottomStackView
    private(set) var bottomStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held in the topStackView
    private(set) var topStackViewItems: [InputBarButtonItem] = []
    
    /// The InputBarItems held to make use of their hooks but they are not automatically added to a UIStackView
    open var nonStackViewItems: [InputBarButtonItem] = []
    
    /// Returns a flatMap of all the items in each of the UIStackViews
    public var items: [InputBarButtonItem] {
        return [leftStackViewItems, rightStackViewItems, bottomStackViewItems, topStackViewItems, nonStackViewItems].flatMap { $0 }
    }

    // MARK: - Auto-Layout Management
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var textViewHeightAnchor: NSLayoutConstraint?
    private var separatorLineTopConstraint: NSLayoutConstraint?
    private var topStackViewHeightAnchor: NSLayoutConstraint?
    private var topStackViewLayoutSet: NSLayoutConstraintSet?
    private var leftStackViewLayoutSet: NSLayoutConstraintSet?
    private var rightStackViewLayoutSet: NSLayoutConstraintSet?
    private var bottomStackViewLayoutSet: NSLayoutConstraintSet?
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
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    open func setup() {
        
        tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        backgroundColor = .clear
        autoresizingMask = [.flexibleHeight, .flexibleBottomMargin]
        attachmentManager.inputBarAccessoryView = self
        setupSubviews()
        setupConstraints()
        setupObservers()
        setupGestureRecognizers()
    }
    
    private func setupSubviews() {
        
        addSubview(backgroundView)
        addSubview(topStackView)
        addSubview(textView)
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(bottomStackView)
        addSubview(separatorLine)
        setStackViewItems([sendButton], forStack: .right, animated: false)
    }
    
    private func setupConstraints() {
        
        topStackViewLayoutSet = NSLayoutConstraintSet(
            top:    topStackView.topAnchor.constraint(equalTo: topAnchor, constant: topStackViewPadding.top),
            bottom: topStackView.bottomAnchor.constraint(equalTo: separatorLine.topAnchor, constant: -topStackViewPadding.bottom),
            left:   topStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: topStackViewPadding.left),
            right:  topStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -topStackViewPadding.right)
        ).activate()
        
        separatorLineTopConstraint = separatorLine.addConstraints(topStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: topStackViewPadding.bottom, heightConstant: 0.5).first
        backgroundView.addConstraints(separatorLine.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        blurView.fillSuperview()
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    textView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: padding.top),
            bottom: textView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -textViewPadding.bottom),
            left:   textView.leftAnchor.constraint(equalTo: leftStackView.rightAnchor, constant: textViewPadding.left),
            right:  textView.rightAnchor.constraint(equalTo: rightStackView.leftAnchor, constant: -textViewPadding.right)
        ).activate()
        textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
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
    
    private func updatePadding() {
        
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
        
        let directions: [UISwipeGestureRecognizerDirection] = [.left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(InputBarAccessoryView.didSwipeTextView(_:)))
            gesture.direction = direction
            textView.addGestureRecognizer(gesture)
        }
    }
    
    // MARK: - Layout Helper Methods
    
    
    /// Layout the given UIStackView's
    ///
    /// - Parameter positions: The UIStackView's to layout
    public func layoutStackViews(_ positions: [UIStackViewPosition] = [.left, .right, .bottom]) {
        
        for position in positions {
            switch position {
            case .left:
                leftStackView.setNeedsLayout()
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.setNeedsLayout()
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.setNeedsLayout()
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.setNeedsLayout()
                topStackView.layoutIfNeeded()
            }
        }
    }
    
    /// Performs layout changes over the main thread
    ///
    /// - Parameters:
    ///   - animated: If the layout should be animated
    ///   - animations: Code
    internal func performLayout(_ animated: Bool, _ animations: @escaping () -> Void) {
        
        textViewLayoutSet?.deactivate()
        leftStackViewLayoutSet?.deactivate()
        rightStackViewLayoutSet?.deactivate()
        bottomStackViewLayoutSet?.deactivate()
        topStackViewLayoutSet?.deactivate()
        if animated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: animations)
            }
        } else {
            UIView.performWithoutAnimation { animations() }
        }
        textViewLayoutSet?.activate()
        leftStackViewLayoutSet?.activate()
        rightStackViewLayoutSet?.activate()
        bottomStackViewLayoutSet?.activate()
        topStackViewLayoutSet?.activate()
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
                    $0.parentStackViewPosition = position
                    leftStackView.addArrangedSubview($0)
                }
                leftStackView.layoutIfNeeded()
            case .right:
                rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                rightStackViewItems = items
                rightStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    rightStackView.addArrangedSubview($0)
                }
                rightStackView.layoutIfNeeded()
            case .bottom:
                bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                bottomStackViewItems = items
                bottomStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    bottomStackView.addArrangedSubview($0)
                }
                bottomStackView.layoutIfNeeded()
            case .top:
                topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                topStackViewItems = items
                topStackViewItems.forEach {
                    $0.inputBarAccessoryView = self
                    $0.parentStackViewPosition = position
                    topStackView.addArrangedSubview($0)
                }
                topStackView.layoutIfNeeded()
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
            self.layoutStackViews([.left])
            self.layoutIfNeeded()
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
            self.layoutStackViews([.right])
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Notifications/Hooks
    
    @objc
    open func orientationDidChange() {
        invalidateIntrinsicContentSize()
    }
    
    @objc
    open func textViewDidChange() {
        
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !textView.text.isEmpty
        items.forEach { $0.textViewDidChangeAction(with: self.textView) }
        delegate?.inputBar(self, textViewTextDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    @objc
    open func textViewDidBeginEditing() {
        items.forEach { $0.keyboardEditingBeginsAction() }
    }
    
    @objc
    open func textViewDidEndEditing() {
        items.forEach { $0.keyboardEditingEndsAction() }
    }
    
    // MARK: - User Actions
    
    @objc
    open func didSwipeTextView(_ gesture: UISwipeGestureRecognizer) {
        items.forEach { $0.keyboardSwipeGestureAction(with: gesture) }
        delegate?.inputBar(self, didSwipeTextViewWith: gesture)
    }
    
    open func didSelectSendButton() {
        delegate?.inputBar(self, didPressSendButtonWith: textView.text)
        textViewDidChange()
        autocompleteManager.checkLastCharacter()
    }
}
