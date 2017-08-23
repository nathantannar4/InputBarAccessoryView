//
//  InputBarAccessoryView.swift
//  NTInputAccessoryView
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

open class InputBarAccessoryView: UIView {
    
    // MARK: - Properties
    
    open weak var delegate: InputBarAccessoryViewDelegate?
    
    open let blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    open let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open let stackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .leading
        view.spacing = 15
        return view
    }()
    
    open let textView: InputTextView = {
        let textView = InputTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    open var textViewPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4) {
        didSet {
            textViewLayoutSet?.bottom?.constant = -textViewPadding.bottom
            textViewLayoutSet?.left?.constant = textViewPadding.left
            textViewLayoutSet?.right?.constant = -textViewPadding.right
        }
    }
    
    open var leftItem: UIView?
    
    open var leftItemSize: CGSize = CGSize(width: 0, height: 36) {
        didSet {
            leftItemLayoutSet?.width?.constant = leftItemSize.width
            leftItemLayoutSet?.height?.constant = leftItemSize.height
        }
    }
    
    open var rightItem: UIView?
    
    open var rightItemSize: CGSize = CGSize(width: 0, height: 36) {
        didSet {
            rightItemLayoutSet?.width?.constant = rightItemSize.width
            rightItemLayoutSet?.height?.constant = rightItemSize.height
        }
    }
    
    open var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    open var stackViewHeight: CGFloat = 0 {
        didSet {
            stackViewLayoutSet?.height?.constant = stackViewHeight
        }
    }
    
    open var maxHeight: CGFloat = 208 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open var isTranslucent: Bool {
        get {
            return blurView.isHidden
        }
        set {
            blurView.isHidden = !newValue
            backgroundColor = newValue ? .clear : .white
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let sizeToFit = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude))
        var heightToFit = sizeToFit.height.rounded() + padding.top + padding.bottom
        if heightToFit >= maxHeight {
            textView.isScrollEnabled = true
            heightToFit = maxHeight
        } else {
            textView.isScrollEnabled = false
        }
        let size = CGSize(width: bounds.width, height: heightToFit)
        if previousIntrinsicContentSize != size {
            delegate?.inputBar?(self, didChangeIntrinsicContentTo: size)
        }
        previousIntrinsicContentSize = size
        return size
    }
    
    private var rightItemContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leftItemContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textViewLayoutSet: NSLayoutConstraintSet?
    private var stackViewLayoutSet: NSLayoutConstraintSet?
    private var rightItemLayoutSet: NSLayoutConstraintSet?
    private var leftItemLayoutSet: NSLayoutConstraintSet?
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
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        setupSubviews()
        setupConstraints()
        setupObservers()
        setupGestureRecognizers()
        setRightItem(sendButton(), animated: false)
    }
    
    private func setupSubviews() {
        
        addSubview(blurView)
        addSubview(separatorLine)
        addSubview(textView)
        addSubview(stackView)
        addSubview(leftItemContainerView)
        addSubview(rightItemContainerView)
    }
    
    private func setupConstraints() {
        
        _ = [
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leftAnchor.constraint(equalTo: leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: rightAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ].map { $0.isActive = true }
        
        _ = [
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leftAnchor.constraint(equalTo: leftAnchor),
            blurView.rightAnchor.constraint(equalTo: rightAnchor)
        ].map { $0.isActive = true }
        
        textViewLayoutSet = NSLayoutConstraintSet(
            top:    textView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            bottom: textView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            left:   textView.leftAnchor.constraint(equalTo: leftItemContainerView.rightAnchor, constant: 4),
            right:  textView.rightAnchor.constraint(equalTo: rightItemContainerView.leftAnchor, constant: -4)
        )
        textViewLayoutSet?.forEach { $0.isActive = true }
        
        stackViewLayoutSet = NSLayoutConstraintSet(
            bottom: stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            left:   stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            right:  stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            height: stackView.heightAnchor.constraint(equalToConstant: 0)
        )
        stackViewLayoutSet?.forEach { $0.isActive = true }
        
        leftItemLayoutSet = NSLayoutConstraintSet(
            bottom: leftItemContainerView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            left:   leftItemContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding.left),
            width:  leftItemContainerView.widthAnchor.constraint(equalToConstant: leftItemSize.width),
            height: leftItemContainerView.heightAnchor.constraint(equalToConstant: leftItemSize.height)
        )
        leftItemLayoutSet?.forEach { $0.isActive = true }
        
        rightItemLayoutSet = NSLayoutConstraintSet(
            bottom: rightItemContainerView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            right:  rightItemContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding.right),
            width:  rightItemContainerView.widthAnchor.constraint(equalToConstant: rightItemSize.width),
            height: rightItemContainerView.heightAnchor.constraint(equalToConstant: rightItemSize.height)
        )
        rightItemLayoutSet?.forEach { $0.isActive = true }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(InputBarAccessoryView.orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InputBarAccessoryView.textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    private func setupGestureRecognizers() {
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(InputBarAccessoryView.didSwipeTextView(_:)))
        rightSwipeGesture.direction = .right
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(InputBarAccessoryView.didSwipeTextView(_:)))
        leftSwipeGesture.direction = .left
        
        textView.addGestureRecognizer(rightSwipeGesture)
        textView.addGestureRecognizer(leftSwipeGesture)
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        textView.tintColor = tintColor
        (rightItem as? InputBarSendButton)?.setTitleColor(tintColor, for: .normal)
        (rightItem as? InputBarSendButton)?.setTitleColor(tintColor.withAlphaComponent(0.3), for: .highlighted)
    }
    
    // MARK: - Methods
    
    open func setRightItem(_ item: UIView?, size: CGSize? = nil, animated: Bool) {
        
        rightItem?.removeFromSuperview()
        
        if let newItem = item {
            // Add/Replace Item
            rightItemContainerView.addSubview(newItem)
            newItem.translatesAutoresizingMaskIntoConstraints = false
            _ = [
                newItem.topAnchor.constraint(equalTo: rightItemContainerView.topAnchor, constant: 0),
                newItem.bottomAnchor.constraint(equalTo: rightItemContainerView.bottomAnchor, constant: 0),
                newItem.leftAnchor.constraint(equalTo: rightItemContainerView.leftAnchor, constant: 0),
                newItem.rightAnchor.constraint(equalTo: rightItemContainerView.rightAnchor, constant: 0)
            ].map { $0.isActive = true }
            rightItem = newItem
            let newSize = size ?? CGSize(width: newItem.intrinsicContentSize.width, height: 36)
            setRightItemSize(newSize, animated: animated)
            
        } else {
            // Remove Item
            rightItem = nil
            setRightItemSize(CGSize(width: 0, height: 36), animated: animated)
        }
    }
    
    open func setRightItemSize(_ size: CGSize, animated: Bool) {
        
        if rightItemSize == size {
            return
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: { 
                self.rightItemSize = size
                self.layoutIfNeeded()
            })
        } else {
            rightItemSize = size
        }
    }
    
    open func setLeftItem(_ item: UIView?, size: CGSize? = nil, animated: Bool) {
        
        leftItem?.removeFromSuperview()
        
        if let newItem = item {
            // Add/Replace Item
            leftItemContainerView.addSubview(newItem)
            newItem.translatesAutoresizingMaskIntoConstraints = false
            _ = [
                newItem.topAnchor.constraint(equalTo: leftItemContainerView.topAnchor, constant: 0),
                newItem.bottomAnchor.constraint(equalTo: leftItemContainerView.bottomAnchor, constant: 0),
                newItem.leftAnchor.constraint(equalTo: leftItemContainerView.leftAnchor, constant: 0),
                newItem.rightAnchor.constraint(equalTo: leftItemContainerView.rightAnchor, constant: 0),
            ].map { $0.isActive = true }
            leftItem = newItem
            let newSize = size ?? CGSize(width: newItem.intrinsicContentSize.width, height: 36)
            setLeftItemSize(newSize, animated: animated)
            
        } else {
            // Remove Item
            leftItem = nil
            setLeftItemSize(CGSize(width: 0, height: 36), animated: animated)
        }
    }
    
    open func setLeftItemSize(_ size: CGSize, animated: Bool) {
        
        if leftItemSize == size {
            return
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftItemSize = size
                self.layoutIfNeeded()
            })
        } else {
            leftItemSize = size
        }
    }
    
    // MARK: - Notifications
    
    open func orientationDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }
    
    open  func textViewDidChange(_ notification: Notification) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        (rightItem as? InputBarSendButton)?.isEnabled = !trimmedText.isEmpty
        delegate?.inputBar?(self, textViewDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - User Actions
    
    open func didSwipeTextView(_ swipeGesture: UISwipeGestureRecognizer) {
        delegate?.inputBar?(self, didSwipeTextViewWith: swipeGesture)
    }
    
    open func didSelectSendButton() {
        delegate?.inputBar?(self, didSelectSendButtonWith: textView.text)
    }
    
    open func didSelectRightItem(_ view: UIView) {
        delegate?.inputBar?(self, didSelectRightItem: view)
    }
    
    open func didSelectLeftItem(_ view: UIView) {
        delegate?.inputBar?(self, didSelectLeftItem: view)
    }
}
