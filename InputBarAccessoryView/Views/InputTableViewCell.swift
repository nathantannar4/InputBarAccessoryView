//
//  InputTableViewCell.swift
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
//  Created by Nathan Tannar on 8/27/17.
//

import UIKit

open class InputTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    open static var reuseIdentifier: String {
        return "InputTableViewCell"
    }
    
    /// A boarder line anchored to the top of the view
    open let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open var prefix: Character? {
        didSet {
            updateTextLabel(toColor: isSelected ? .white : .black)
        }
    }
    
    open var autocompleteText: String? {
        didSet {
            updateTextLabel(toColor: isSelected ? .white : .black)
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        
        selectionStyle = .none
        addSubview(separatorLine)
        separatorLine.addConstraints(topAnchor, left: leftAnchor, right: rightAnchor, heightConstant: 0.5)
    }

    open func updateTextLabel(toColor color: UIColor) {
        
        let title = NSMutableAttributedString()
        if let char = prefix {
            let size = textLabel?.font.pointSize ?? 14
            let attrs: [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.boldSystemFont(ofSize: size),NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : color]
            let boldPrefix = NSMutableAttributedString(string: String(char), attributes: attrs)
            title.append(boldPrefix)
        }
        if let text = autocompleteText {
            let attrs: [NSAttributedStringKey:AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : color]
            let attributedTitle = NSAttributedString(string: text, attributes: attrs)
            title.append(attributedTitle)
        }
        textLabel?.attributedText = title
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setSelected(true, animated: true)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setSelected(false, animated: true)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setSelected(false, animated: true)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        func animation() {
            if selected {
                backgroundColor = tintColor
                updateTextLabel(toColor: .white)
                imageView?.tintColor = .white
            } else {
                backgroundColor = .white
                updateTextLabel(toColor: .black)
                imageView?.tintColor = tintColor
            }
        }
        if animated {
            UIView.animate(withDuration:  selected ? 0.3 : 1) {
                animation()
            }
        } else {
            animation()
        }
    }
}
