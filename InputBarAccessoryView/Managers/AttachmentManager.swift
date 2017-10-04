//
//  AttachmentManager.swift
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
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit

open class AttachmentManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    open lazy var attachmentView: AttachmentsView = { [weak self] in
        let attachmentView = AttachmentsView()
        attachmentView.dataSource = self
        attachmentView.delegate = self
        return attachmentView
    }()
    
    open var attachments = [AnyObject]() {
        didSet {
            attachmentView.reloadData()
            inputBarAccessoryView?.isAttachmentViewHidden = attachments.count == 0
        }
    }
    
    /// Performs an animated insertion of an attachment at an index
    ///
    /// - Parameter index: The index to insert the attachment at
    open func insertAttachment(_ attachment: AnyObject, at index: Int) {
        
        inputBarAccessoryView?.isAttachmentViewHidden = false
        attachmentView.performBatchUpdates({
            self.attachments.insert(attachment, at: index)
            self.attachmentView.insertItems(at: [IndexPath(row: index, section: 0)])
        }, completion: { success in
            self.attachmentView.reloadData()
        })
    }
    
    /// Performs an animated removal of an attachment at an index
    ///
    /// - Parameter index: The index to remove the attachment at
    open func removeAttachment(at index: Int) {
        
        attachmentView.performBatchUpdates({
            self.attachments.remove(at: index)
            self.attachmentView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }, completion: { success in
            self.attachmentView.reloadData()
            self.inputBarAccessoryView?.isAttachmentViewHidden = self.attachments.count == 0
        })
    }

    // MARK: - UICollectionViewDataSource
    
    open func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let image = attachments[indexPath.row] as? UIImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAttachmentCell.reuseIdentifier, for: indexPath) as? ImageAttachmentCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            }
            cell.indexPath = indexPath
            cell.manager = self
            cell.imageView.image = image
            cell.removeButton.backgroundColor = inputBarAccessoryView?.tintColor ?? .lightGray
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = collectionView.frame.height
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            height -= (layout.sectionInset.bottom + layout.sectionInset.top)
        }
        return CGSize(width: height, height: height)
    }
}
