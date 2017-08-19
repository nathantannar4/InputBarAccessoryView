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

open class InputBarItem<T : UIView>: UIView {
    
    open var element: T
    
    public enum Spacing {
        case none
        case flexible
        case fixed(CGFloat)
    }
    
    open weak var target: AnyObject?
    
    open var action: Selector?
    
    open var spacing: Spacing = .none
    
    /// Content inset
    public var contentInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    // MARK: - Initialization
    
    public init() {
        self.element = T()
        super.init(frame: .zero)
        addSubview(element)
        element.constrainToSuperview()
    }
    
    public init(element: T) {
        self.element = element
        super.init(frame: .zero)
        addSubview(element)
        element.constrainToSuperview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var intrinsicContentSize: CGSize {
        
//        if let label: UILabel = self.titleLabel {
//            let size: CGSize = label.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//            return CGSize(width: self.contentInset.left + size.width + self.contentInset.right, height: size.height)
//        }
//        
//        if let view: UIImageView = self.imageView {
//            let size: CGSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//            return CGSize(width: self.contentInset.left + size.width + self.contentInset.right, height: size.height)
//        }
      
        let size = element.systemLayoutSizeFitting(<#T##targetSize: CGSize##CGSize#>, withHorizontalFittingPriority: UILayoutPriority., verticalFittingPriority: <#T##UILayoutPriority#>)
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height)
        
        switch self.spacing {
            case .flexible:
                return CGSize(width: 1, height: 1)
            case .fixed(let width):
                return CGSize(width: width, height: 1)
            default:
                return super.intrinsicContentSize
        }
    }
}
