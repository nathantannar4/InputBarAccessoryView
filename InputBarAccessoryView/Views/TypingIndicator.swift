//
//  TypingIndicator.swift
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
//  Created by Nathan Tannar on 2/11/18.
//

import UIKit

/// A view designed to be placed in an `InputStackView` as a Slack style typing indicator
open class TypingIndicator: UIView, InputItem {
    
    // MARK: - Properties [Public]
    
    /// A delegate to broadcast notifications from the `TypingIndicator`
    open weak var delegate: TypingIndicatorDelegate?
    
    open override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + labelEdgeInsets.left + labelEdgeInsets.right,
                      height: labelSize.height + labelEdgeInsets.top + labelEdgeInsets.bottom)
    }
    
    /// An array of names/ids that will be parsed and displayed as the typing users
    public private(set) var usersTyping: [String] = []
    
    open let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// A boarder line anchored to the bottom of the view
    open let separatorLine = SeparatorLine()
    
    open var labelEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    // MARK: - Properties [Private]
    
    private var labelConstraintSet: NSLayoutConstraintSet?
    private var currentUserIsTyping: Bool = false
    
    // MARK: - InputItem Properties
    
    open var inputBarAccessoryView: InputBarAccessoryView?
    
    open var parentStackViewPosition: InputStackView.Position?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API [Public]
    
    /// Sets a new list of users who are typing and updates the label/UI
    ///
    /// - Parameter users: The new group of names/ids to display as typing
    open func setUsersTyping(to users: [String]) {
        
        usersTyping = users
        
        // Make some UI changes
        let isTyping = usersTyping.count != 0
        separatorLine.isHidden = !isTyping
        inputBarAccessoryView?.separatorLine.backgroundColor = isTyping ? .clear : .lightGray
        labelConstraintSet?.top?.constant = isTyping ? 2 : 0
        labelConstraintSet?.bottom?.constant = isTyping ? -2 : 0
        
        // Assumes being placed in the topStackView which is constrained to safeArea, thus the extra space behind the topStackView should be set to backgroundColor
        inputBarAccessoryView?.backgroundColor = isTyping ? backgroundColor : inputBarAccessoryView?.backgroundView.backgroundColor
        
        let fontSize = label.font.pointSize
        let textColor = label.textColor ?? .darkGray
        switch usersTyping.count {
        case 0:
            label.attributedText = nil
        case 1:
            label.attributedText = NSMutableAttributedString()
                .bold(usersTyping[0], fontSize: fontSize, textColor: textColor)
                .normal(" is typing...", fontSize: fontSize, textColor: textColor)
        case 2:
            label.attributedText = NSMutableAttributedString()
                .bold(usersTyping[0], fontSize: fontSize, textColor: textColor)
                .normal(" and ", fontSize: fontSize, textColor: textColor)
                .bold(usersTyping[1], fontSize: fontSize, textColor: textColor)
                .normal(" are typing...", fontSize: fontSize, textColor: textColor)
        default:
            label.attributedText = NSMutableAttributedString()
                .normal("Multiple users are typing...", fontSize: fontSize, textColor: textColor)
        }
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - API [Private]
    
    private func setup() {
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        separatorLine.isHidden = true
        
        addSubview(separatorLine)
        addSubview(label)
        labelConstraintSet = NSLayoutConstraintSet(
            top: label.topAnchor.constraint(equalTo: topAnchor, constant: labelEdgeInsets.top),
            bottom: label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -labelEdgeInsets.bottom),
            left: label.leftAnchor.constraint(equalTo: leftAnchor, constant: labelEdgeInsets.left),
            right: label.rightAnchor.constraint(equalTo: rightAnchor, constant: -labelEdgeInsets.right)
        ).activate()
        separatorLine.addConstraints(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: separatorLine.height)
    }
    
    // MARK: - InputItem Methods
    
    /// Indicates when the current user is typing
    open func textViewDidChangeAction(with textView: InputTextView) {
        let isTyping = !textView.attributedText.string.isEmpty
        guard isTyping != currentUserIsTyping else { return }
        currentUserIsTyping = isTyping
        delegate?.typingIndicator(self, currentUserIsTyping: isTyping)
    }
    
    /// Does nothing
    open func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {}
    
    /// Indicates that the current user has completed typing
    open func keyboardEditingEndsAction() {
        delegate?.typingIndicator(self, currentUserIsTyping: false)
    }
    
    /// Does nothing
    open func keyboardEditingBeginsAction() {}
    
}
