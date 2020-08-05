//
//  RxInputBarAccessoryView.swift
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
//  Created by Nathan Tannar on 9/13/18.
//

import UIKit
import RxSwift
import RxCocoa

public final class RxInputBarAccessoryViewDelegate:
    DelegateProxy<InputBarAccessoryView, InputBarAccessoryViewDelegate>,
    DelegateProxyType,
InputBarAccessoryViewDelegate {

    public var sendText: Observable<String> {
        return _sendText.asObservable()
    }

    public var currentText: Observable<String> {
        return _currentText.asObservable()
    }

    public var intrinsicContentSize: Observable<CGSize> {
        return _intrinsicContentSize.asObservable()
    }

    public var swipeGesture: Observable<UISwipeGestureRecognizer> {
        return _swipeGesture.asObservable()
    }

    private let _sendText = PublishSubject<String>()
    private let _currentText = PublishSubject<String>()
    private let _intrinsicContentSize = PublishSubject<CGSize>()
    private let _swipeGesture = PublishSubject<UISwipeGestureRecognizer>()

    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        _sendText.onNext(text)
    }

    public func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        _currentText.onNext(text)
    }

    public func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        _intrinsicContentSize.onNext(size)
    }

    public func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        _swipeGesture.onNext(gesture)
    }

    public static func registerKnownImplementations() {
        register {
            RxInputBarAccessoryViewDelegate(
                parentObject: $0,
                delegateProxy: RxInputBarAccessoryViewDelegate.self
            )
        }
    }

    public static func currentDelegate(for object: InputBarAccessoryView) -> InputBarAccessoryViewDelegate? {
        return object.delegate
    }

    public static func setCurrentDelegate(_ delegate: InputBarAccessoryViewDelegate?, to object: InputBarAccessoryView) {
        object.delegate = delegate
    }
}

extension InputBarAccessoryView {
    public var rx_delegate: RxInputBarAccessoryViewDelegate {
        return RxInputBarAccessoryViewDelegate.proxy(for: self)
    }
}

extension Reactive where Base: InputBarAccessoryView {
    public var isTranslucent: Binder<Bool> {
        return Binder(base) { inputBar, newValue in
            inputBar.isTranslucent = newValue
        }
    }

    public var shouldAutoUpdateMaxTextViewHeight: Binder<Bool> {
        return Binder(base) { inputBar, newValue in
            inputBar.shouldAutoUpdateMaxTextViewHeight = newValue
        }
    }

    public var maxTextViewHeight: Binder<CGFloat> {
        return Binder(base) { inputBar, newValue in
            inputBar.maxTextViewHeight = newValue
        }
    }

    public var shouldManageSendButtonEnabledState: Binder<Bool> {
        return Binder(base) { inputBar, newValue in
            inputBar.shouldManageSendButtonEnabledState = newValue
        }
    }

    public var leftStackViewItems: Binder<[InputItem]> {
        return Binder(base) { inputBar, newValue in
            inputBar.setStackViewItems(newValue, forStack: .left, animated: false)
        }
    }

    public var rightStackViewItems: Binder<[InputItem]> {
        return Binder(base) { inputBar, newValue in
            inputBar.setStackViewItems(newValue, forStack: .right, animated: false)
        }
    }

    public var topStackViewItems: Binder<[InputItem]> {
        return Binder(base) { inputBar, newValue in
            inputBar.setStackViewItems(newValue, forStack: .top, animated: false)
        }
    }

    public var bottomStackViewItems: Binder<[InputItem]> {
        return Binder(base) { inputBar, newValue in
            inputBar.setStackViewItems(newValue, forStack: .bottom, animated: false)
        }
    }

    public var leftStackViewWidthConstant: Binder<CGFloat> {
        return Binder(base) { inputBar, newValue in
            inputBar.setLeftStackViewWidthConstant(to: newValue, animated: false)
        }
    }

    public var rightStackViewWidthConstant: Binder<CGFloat> {
        return Binder(base) { inputBar, newValue in
            inputBar.setRightStackViewWidthConstant(to: newValue, animated: false)
        }
    }

    public var shouldForceMaxTextViewHeight: Binder<Bool> {
        return Binder(base) { inputBar, newValue in
            inputBar.setShouldForceMaxTextViewHeight(to: newValue, animated: false)
        }
    }
}

extension Reactive where Base: InputBarButtonItem {
    public var size: Binder<CGSize?> {
        return Binder(base) { item, newValue in
            item.setSize(newValue, animated: false)
        }
    }

    public var spacing: Binder<InputBarButtonItem.Spacing> {
        return Binder(base) { item, newValue in
            item.spacing = newValue
        }
    }
}

extension Reactive where Base: InputBarSendButton {
    public var isAnimating: Binder<Bool> {
        return Binder(base) { item, newValue in
            if newValue {
                item.startAnimating()
            } else {
                item.stopAnimating()
            }
        }
    }
}

extension Reactive where Base: InputBarViewController {
    public var isInputBarHidden: Binder<Bool> {
        return Binder(base) { viewController, newValue in
            viewController.isInputBarHidden = newValue
        }
    }
}
