//
//  GitHawkInputBar.swift
//  Example
//
//  Created by Nathan Tannar on 2018-06-06.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class GitHawkInputBar: InputBarAccessoryView {
    
    private let githawkImages: [UIImage] = [#imageLiteral(resourceName: "ic_eye"), #imageLiteral(resourceName: "ic_bold"), #imageLiteral(resourceName: "ic_italic"), #imageLiteral(resourceName: "ic_at"), #imageLiteral(resourceName: "ic_list"), #imageLiteral(resourceName: "ic_code"), #imageLiteral(resourceName: "ic_link"), #imageLiteral(resourceName: "ic_hashtag"), #imageLiteral(resourceName: "ic_upload")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        inputTextView.placeholder = "Leave a comment"
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_send").withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = tintColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 20, height: 20)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        let collectionView = AttachmentCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.intrinsicContentHeight = 20
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        bottomStackView.addArrangedSubview(collectionView)
        collectionView.reloadData()
    }
    
}

extension GitHawkInputBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return githawkImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        cell.imageView.image = githawkImages[indexPath.section].withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = .black
        return cell
    }
    
}
