//
//  InputBarItem.swift
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

import UIKit

open class InputBarItem: UIButton {
    
    public enum Spacing {
        case fixed(CGFloat)
        case flexible
        case none
    }
    
    // MARK: - Properties
    
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    public var spacing: Spacing = .none {
        didSet {
            switch spacing {
            case .flexible:
                setContentHuggingPriority(1, for: .horizontal)
                setContentHuggingPriority(1, for: .vertical)
            case .fixed:
                setContentHuggingPriority(1000, for: .horizontal)
                setContentHuggingPriority(1000, for: .vertical)
            case .none:
                setContentHuggingPriority(500, for: .horizontal)
                setContentHuggingPriority(500, for: .vertical)
            }
        }
    }
    
    open var onTouchUpInsideAction: ((InputBarItem)->Void)?
    open var onKeyboardEditingBeginsAction: ((InputBarItem)->Void)?
    open var onKeyboardEditingEndsAction: ((InputBarItem)->Void)?
    
    open var size: CGSize? = nil {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = size ?? super.intrinsicContentSize
        switch spacing {
        case .fixed(let width):
            contentSize.width += width
        default:
            break
        }
        return contentSize
    }
    
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
    
    open func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        setContentHuggingPriority(500, for: .horizontal)
        setContentHuggingPriority(500, for: .vertical)
        addTarget(self, action: #selector(InputBarItem.executeTouchUpInsideAction), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    @discardableResult
    open func configure(_ setup: (InputBarItem)->Void) -> Self {
        setup(self)
        return self
    }
    
    @discardableResult
    open func onKeyboardEditingBegins(_ action: @escaping (InputBarItem)->Void) -> Self {
        onKeyboardEditingBeginsAction = action
        return self
    }
    
    @discardableResult
    open func onKeyboardEditingEnds(_ action: @escaping (InputBarItem)->Void) -> Self {
        onKeyboardEditingEndsAction = action
        return self
    }
    
    @discardableResult
    open func onTouchUpInside(_ action: @escaping (InputBarItem)->Void) -> Self {
        onTouchUpInsideAction = action
        return self
    }
    
    func executeTouchUpInsideAction() {
        onTouchUpInsideAction?(self)
    }
    
    // MARK: - Static vars
    
    open static var flexibleSpace: InputBarItem {
        let item = InputBarItem()
        item.size = .zero
        item.spacing = .flexible
        return item
    }
    
    open static func fixedSpace(_ width: CGFloat) -> InputBarItem {
        let item = InputBarItem()
        item.size = .zero
        item.spacing = .fixed(width)
        return item
    }
}
