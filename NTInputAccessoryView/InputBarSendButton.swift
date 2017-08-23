//
//  InputBarSendButton.swift
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
//  Created by Nathan Tannar on 8/19/17.
//

import UIKit

open class InputBarSendButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isEnabled = false
        setTitle("Send", for: .normal)
        setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.3), for: .highlighted)
        setTitleColor(.lightGray, for: .disabled)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
    }
    
    // MARK: - Touch Methods
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
}

public extension InputBarAccessoryView {
    
    public func sendButton() -> InputBarSendButton {
        
        let button = InputBarSendButton()
        button.addTarget(self, action: #selector(InputBarAccessoryView.didSelectRightItem(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(InputBarAccessoryView.didSelectSendButton), for: .touchUpInside)
        return button
    }
}
