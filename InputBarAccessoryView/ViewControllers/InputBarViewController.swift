//
//  InputBarViewController.swift
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
//  Created by Nathan Tannar on 9/13/18.
//

import UIKit

/// An simple `UIViewController` subclass that is ready to work
/// with an `inputAccessoryView`
open class InputBarViewController: UIViewController, InputBarAccessoryViewDelegate {

    /// A powerful InputAccessoryView ideal for messaging applications
    public let inputBar = InputBarAccessoryView()

    /// A boolean value that when changed will update the `inputAccessoryView`
    /// of the `InputBarViewController`. When set to `TRUE`, the
    /// `inputAccessoryView` is set to `nil` and the `inputBar` slides off
    /// the screen.
    ///
    /// The default value is FALSE
    open var isInputBarHidden: Bool = false {
        didSet {
            isInputBarHiddenDidChange()
        }
    }

    open override var inputAccessoryView: UIView? {
        return isInputBarHidden ? nil : inputBar
    }

    open override var canBecomeFirstResponder: Bool {
        return !isInputBarHidden
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        inputBar.delegate = self
    }

    /// Invoked when `isInputBarHidden` changes to become or
    /// resign first responder
    open func isInputBarHiddenDidChange() {
        if isInputBarHidden, isFirstResponder {
            resignFirstResponder()
        } else if !isFirstResponder {
            becomeFirstResponder()
        }
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        inputBar.inputTextView.resignFirstResponder()
        return super.resignFirstResponder()
    }

    // MARK: - InputBarAccessoryViewDelegate

    open func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) { }

    open func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) { }

    open func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) { }

    open func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) { }
}

