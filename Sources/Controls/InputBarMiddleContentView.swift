//
//  InputBarMiddleContentView.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2019 Nathan Tannar.
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
//  Created by Marc Etcheverry on 7/12/19.
//

import UIKit

public protocol InputBarMiddleContentViewDelegate: class {
    func inputTextViewDidChange()
    func inputTextViewDidBeginEditing()
    func inputTextViewDidEndEditing()
    func didSwipeTextView(_ gesture: UISwipeGestureRecognizer)
}

/// You can adopt this protocol to implement a middle content view that goes beyond a simple `InputTextView`
/// You must have a principal `InputTextView` as this is a requirement for `InputBarAccessoryView`.
/// `isScrollEnabled` will be called by `InputBarAccessoryView` if max height is constrained for the middle content view.
public protocol InputBarMiddleContentView: UIView {
    var delegate: InputBarMiddleContentViewDelegate? { get set }
    var canSend: Bool { get }
    var isScrollEnabled: Bool { get set }
    var inputTextView: InputTextView { get set }
}

/// A default implementation of `InputBarMiddleContentView` with one `InputTextView`
internal class InputBarDefaultMiddleContentView: UIView, InputBarMiddleContentView {
    weak var delegate: InputBarMiddleContentViewDelegate?

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

    private func setup() {
        addSubview(inputTextView)
        inputTextView.fillSuperview()

        setupObservers()
        setupGestureRecognizers()
    }

    /// Adds a UISwipeGestureRecognizer for each direction to the InputTextView
    private func setupGestureRecognizers() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(InputBarDefaultMiddleContentView.didSwipeTextView(_:)))
            gesture.direction = direction
            inputTextView.addGestureRecognizer(gesture)
        }
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarDefaultMiddleContentView.inputTextViewDidChange),
                                               name: UITextView.textDidChangeNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarDefaultMiddleContentView.inputTextViewDidBeginEditing),
                                               name: UITextView.textDidBeginEditingNotification, object: inputTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InputBarDefaultMiddleContentView.inputTextViewDidEndEditing),
                                               name: UITextView.textDidEndEditingNotification, object: inputTextView)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification, object: inputTextView)
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidBeginEditingNotification, object: inputTextView)
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidEndEditingNotification, object: inputTextView)
    }

    @objc
    open func inputTextViewDidChange() {
        delegate?.inputTextViewDidChange()
    }

    @objc
    open func inputTextViewDidBeginEditing() {
        delegate?.inputTextViewDidBeginEditing()
    }

    @objc
    open func inputTextViewDidEndEditing() {
        delegate?.inputTextViewDidEndEditing()
    }

    /// Calls each items `keyboardSwipeGestureAction` method
    /// Calls the delegates `didSwipeTextViewWith` method
    @objc
    open func didSwipeTextView(_ gesture: UISwipeGestureRecognizer) {
        delegate?.didSwipeTextView(gesture)
    }

    var canSend: Bool {
        let trimmedText = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        var isEnabled = !trimmedText.isEmpty
        if !isEnabled {
            // The images property is more resource intensive so only use it if needed
            isEnabled = inputTextView.images.count > 0
        }
        return isEnabled
    }

    var isScrollEnabled: Bool {
        get {
            return inputTextView.isScrollEnabled
        }
        set {
            inputTextView.isScrollEnabled = newValue
        }
    }

    override var intrinsicContentSize: CGSize {
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        return CGSize(width: bounds.width, height: ceil(inputTextView.sizeThatFits(maxTextViewSize).height))
    }

    lazy var inputTextView: InputTextView = {
        let inputTextView = InputTextView()
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        return inputTextView
    }()
}

