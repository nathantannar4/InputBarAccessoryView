//
//  AutocompleteCollectionView.swift
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

open class AutocompleteCollectionView: UICollectionView {
    
    public enum ScrollDirection {
        case vertical
        case horizontal
    }
    
    /// Scroll direction,
    open var scrollDirection = ScrollDirection.vertical {
        didSet {
            updateLayoutForScrollDirection()
        }
    }
    
    open var itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44) {
        didSet {
            updateLayoutForScrollDirection()
        }
    }
    
    // This property takes effect only when scrollDirection is set to .vertical.
    open var maxVisibleItems = 3 { didSet { invalidateIntrinsicContentSize() } }
    
    private func updateLayoutForScrollDirection() {
        showsHorizontalScrollIndicator = scrollDirection != .horizontal
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
            flowLayout.itemSize = itemSize
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        }
        invalidateIntrinsicContentSize()
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        updateLayoutForScrollDirection()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateLayoutForScrollDirection()
    }
    
    open override var intrinsicContentSize: CGSize {

        switch scrollDirection {
        case .horizontal:
            let numberOfItems = numberOfItems(inSection: 0)
            return CGSize(width: super.intrinsicContentSize.width, height: numberOfItems > 0 ? itemSize.height : 0.0)
        case .vertical:
            let rowCount = numberOfItems(inSection: 0) < maxVisibleItems ? numberOfItems(inSection: 0) : maxVisibleItems
            return CGSize(width: super.intrinsicContentSize.width, height: (CGFloat(rowCount) * itemSize.height))
        }
    }
    
}
