//
//  AutocompleteCell.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

open class AutocompleteCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    open class var reuseIdentifier: String {
        return "AutocompleteCell"
    }
    
    /// A border line anchored to the top of the view
    public let separatorLine = SeparatorLine()
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        return imageView
    }()
    
    open lazy var textLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        return label
    }()
    
    open lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        contentView.addSubview(imageView)
        return imageView
    }()
    
    /// By setting this property, you can indirectly adjust the size of the imageView.
    open var imageViewEdgeInsets: UIEdgeInsets = .zero { didSet { setNeedsLayout() } }
    
    /// The scroll direction of the parent collection view
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            separatorLine.isHidden = scrollDirection == .horizontal
            textLabel.textAlignment = scrollDirection == .horizontal ? .center : .natural
            setNeedsLayout()
        }
    }

    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        imageViewEdgeInsets = .zero
        separatorLine.backgroundColor = .systemGray2
        separatorLine.isHidden = false
        checkmarkImageView.isHidden = true
    }
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(separatorLine)
    }
    
    // MARK: - Update Selection State
    
    open var isCheckmarkSelected: Bool = false {
        didSet {
            checkmarkImageView.isHidden = !isCheckmarkSelected
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        switch scrollDirection {
        case .horizontal:
            // Only set the imageView frame if image exists
            if let _ = imageView.image {
                let imageViewWidth = 36.0
                let imageViewHeight = 36.0
                let imageViewX = (bounds.width - imageViewWidth) / 2.0
                let imageViewY = 16.0
                
                imageView.frame = CGRect(x: imageViewX + imageViewEdgeInsets.left,
                                         y: imageViewY + imageViewEdgeInsets.top,
                                         width: imageViewWidth - imageViewEdgeInsets.left - imageViewEdgeInsets.right,
                                         height: imageViewHeight - imageViewEdgeInsets.top - imageViewEdgeInsets.bottom)
            } else {
                imageView.frame = .zero
            }
            
            // Only set the textLabel frame if text exists
            if let text = textLabel.text, !text.isEmpty {
                let textLabelPadding = 5.0
                let textLabelX = 8.0
                let textLabelY = imageView.frame.maxY + textLabelPadding
                let textLabelWidth = bounds.size.width - textLabelX * 2
                let textLabelHeight = textLabel.font.pointSize
                textLabel.frame = CGRect(x: textLabelX,
                                         y: textLabelY,
                                         width: textLabelWidth,
                                         height: textLabelHeight)
            } else {
                textLabel.frame = .zero
            }
            
            checkmarkImageView.frame = CGRect(x: bounds.width - 30, y: 10, width: 20, height: 20)
        case .vertical:
            separatorLine.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0.5)
            
            // Only set the imageView frame if image exists
            if let _ = imageView.image {
                let imageViewWidth = 30.0
                let imageViewHeight = 30.0
                let imageViewX = 16.0
                let imageViewY = (bounds.height - imageViewHeight) / 2.0

                imageView.frame = CGRect(x: imageViewX + imageViewEdgeInsets.left,
                                         y: imageViewY + imageViewEdgeInsets.top,
                                         width: imageViewWidth - imageViewEdgeInsets.left - imageViewEdgeInsets.right,
                                         height: imageViewHeight - imageViewEdgeInsets.top - imageViewEdgeInsets.bottom)
            } else {
                imageView.frame = .zero
            }
            
            // Only set the textLabel frame if text exists
            if let text = textLabel.text, !text.isEmpty {
                let textLabelPadding = 8.0
                let textLabelWidth = bounds.width - imageView.frame.maxX - textLabelPadding
                let textLabelHeight = 30.0
                let textLabelX = imageView.frame.maxX + textLabelPadding
                let textLabelY = (bounds.height - textLabelHeight) / 2.0
                textLabel.frame = CGRect(x: textLabelX,
                                         y: textLabelY,
                                         width: textLabelWidth,
                                         height: textLabelHeight)
            } else {
                textLabel.frame = .zero
            }
            
            checkmarkImageView.frame = CGRect(x: bounds.width - 30, y: 10, width: 20, height: 20)
        @unknown default:
            break
        }
    }
}
