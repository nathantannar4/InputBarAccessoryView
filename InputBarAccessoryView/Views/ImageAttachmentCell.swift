//
//  ImageAttachmentCell.swift
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

open class ImageAttachmentCell: UICollectionViewCell, AttachmentCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return "ImageAttachmentCell"
    }
    
    open let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    open lazy var removeButton: UIButton = { [weak self] in
        let button = UIButton()
        button.setAttributedTitle(NSMutableAttributedString().bold("X", fontSize: 15, textColor: .white), for: .normal)
        button.setAttributedTitle(NSMutableAttributedString().bold("X", fontSize: 15, textColor: UIColor.white.withAlphaComponent(0.5)), for: .highlighted)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(removeAttachment), for: .touchUpInside)
        return button
    }()
    
    open var indexPath: IndexPath?
    
    open weak var manager: AttachmentManager?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
        manager = nil
        imageView.image = nil
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
    }
    
    private func setupConstraints() {
        
        imageView.addConstraints(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 4, rightConstant: 10)
        removeButton.addConstraints(contentView.topAnchor, right: contentView.rightAnchor, widthConstant: 20, heightConstant: 20)
    }
    
    // User Actions
    
    @objc
    func removeAttachment() {
        
        guard let index = indexPath?.row else { return }
        manager?.removeAttachment(at: index)
    }
}
