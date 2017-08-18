//
//  UITextInputAccessoryView.swift
//  UITextInputAccessoryView
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
//  Created by Nathan Tannar on 8/13/17.
//

import UIKit

@objc
public protocol UITextInputAccessoryViewDelegate: NSObjectProtocol {
    @objc optional func textInput(_ textInput: UITextInputAccessoryView, contentSizeDidChangeTo Size: CGSize)
    @objc optional func textInput(_ textInput: UITextInputAccessoryView, textDidChangeTo text: String)
    @objc optional func textInput(_ textInput: UITextInputAccessoryView, didPressSendButtonWith text: String)
    @objc optional func textInput(_ textInput: UITextInputAccessoryView, didPressAccessoryButtonWith text: String)
}

open class UITextInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    open weak var delegate: UITextInputAccessoryViewDelegate?
    
    open let textView: NTTextInputView = {
        let textView = NTTextInputView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        textView.textColor = .black
        textView.placeholder = "Aa"
        textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 16.0
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.placeholderInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return textView
    }()
    
    open lazy var sendButton: UIButton = { [unowned self] in
        
        class CustomButton: UIButton {
            
            override func tintColorDidChange() {
                super.tintColorDidChange()
                setTitleColor(tintColor, for: .normal)
                setTitleColor(tintColor.withAlphaComponent(0.3), for: .highlighted)
            }
        }
        
        let button = CustomButton()
        button.setTitle("Send", for: .normal)
        button.tintColor = .lightBlue
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.isEnabled = false
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(didPressSendButton(_:)), for: .touchUpInside)
        return button
    }()
    
    open lazy var accessoryButton: UIButton = { [unowned self] in
        
        class CustomButton: UIButton {
            
            private var originalTint: UIColor?
            
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                originalTint = tintColor
                tintColor = tintColor.withAlphaComponent(0.3)
            }
            
            override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                tintColor = originalTint
            }
            
            override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                tintColor = originalTint
            }
        }
        
        let button = CustomButton()
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.adjustsImageWhenHighlighted = false
        let image = UIImage(named: "icons8-plus_math")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = self.accessoryButtonWidth / 2
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(didPressAccessoryButton(_:)), for: .touchUpInside)
        return button
    }()
    
    open var maxHeight: CGFloat = 300
    
    open var isTranslucent: Bool = false {
        didSet {
            if isTranslucent {
                nonTranslucentBackgroundColor = backgroundColor
                backgroundColor = backgroundColor?.withAlphaComponent(0.9)
            } else {
                backgroundColor = nonTranslucentBackgroundColor
            }
        }
    }
    
    open var alwaysHideAccessoryButton: Bool = false {
        willSet {
            isAccessoryButtonHidden = alwaysHideAccessoryButton
        }
        didSet {
            isAccessoryButtonHidden = alwaysHideAccessoryButton
        }
    }
    
    open var isAccessoryButtonHidden: Bool {
        get {
            return textViewLeftAnchor?.constant == padding / 2
        }
        set {
            if alwaysHideAccessoryButton {
                return
            }
            layoutIfNeeded()
            let isHidden = isAccessoryButtonHidden
            UIView.animate(withDuration: 0.3) {
                self.textViewLeftAnchor?.constant = isHidden ? self.padding + self.accessoryButtonWidth : self.padding / 2
                self.layoutIfNeeded()
            }
        }
    }
    
    open var padding: CGFloat {
        return 8
    }
    
    open var accessoryButtonWidth: CGFloat {
        return 30
    }
    
    private var previousContentSize: CGSize = .zero
    private var nonTranslucentBackgroundColor: UIColor? = .white
    private var textViewLeftAnchor: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupConstraints()
        setupGestureRecognizers()
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        sendButton.tintColor = tintColor
        accessoryButton.backgroundColor = tintColor
    }
    
    open func orientationDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }
    
    open func showAccessoryButton() {
        if alwaysHideAccessoryButton {
            return
        }
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.textViewLeftAnchor?.constant = self.padding + self.accessoryButtonWidth
            self.layoutIfNeeded()
        }
    }
    
    open  func textViewDidChange(_ notification: Notification) {
        if textView.text.isEmpty && isAccessoryButtonHidden {
            isAccessoryButtonHidden = false
        } else if !textView.text.isEmpty && !isAccessoryButtonHidden {
            isAccessoryButtonHidden = true
        }
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !trimmedText.isEmpty
        delegate?.textInput?(self, textDidChangeTo: trimmedText)
        invalidateIntrinsicContentSize()
    }
    
    override open var intrinsicContentSize: CGSize {
        let sizeToFit = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude))
        var heightToFit = sizeToFit.height.rounded() + padding
        if heightToFit >= maxHeight {
            textView.isScrollEnabled = true
//            layer.cornerRadius = 10
            heightToFit = maxHeight
        } else {
            textView.isScrollEnabled = false
//            layer.cornerRadius = 0
        }
        let size = CGSize(width: bounds.width, height: heightToFit)
        if previousContentSize != size {
            delegate?.textInput?(self, contentSizeDidChangeTo: size)
        }
        previousContentSize = size
        return size
    }
    
    open func setupSubviews() {
        
        addSubview(sendButton)
        addSubview(accessoryButton)
        addSubview(textView)
    }
    
    open func setupConstraints() {
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        accessoryButton.translatesAutoresizingMaskIntoConstraints = false
        
//        textViewLeftAnchor = textView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding + accessoryButtonWidth)
//        _ = [
//            accessoryButton.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
//            accessoryButton.leftAnchor.constraint(equalTo: leftAnchor, constant: padding / 2),
//            accessoryButton.widthAnchor.constraint(equalToConstant: accessoryButtonWidth),
//            accessoryButton.heightAnchor.constraint(equalToConstant: accessoryButtonWidth),
//            textView.topAnchor.constraint(equalTo: topAnchor, constant: padding / 2),
//            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding / 2),
//            textView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -padding / 2),
//            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor),
//            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding / 2),
//            sendButton.widthAnchor.constraint(equalToConstant: 60),
//            sendButton.heightAnchor.constraint(equalToConstant: 44)
//        ].map { $0.isActive = true }
//        textViewLeftAnchor?.isActive = true
    }
    
    open func setupGestureRecognizers() {
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showAccessoryButton))
        swipeGesture.direction = .right
        textView.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: - Actions 
    
    open func didPressSendButton(_ sender: AnyObject?) {
        delegate?.textInput?(self, didPressSendButtonWith: textView.text)
    }
    
    open func didPressAccessoryButton(_ sender: AnyObject?) {
        delegate?.textInput?(self, didPressAccessoryButtonWith: textView.text)
    }
}

public extension UIColor {
    
    static var lightBlue: UIColor {
        return UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    }
}
