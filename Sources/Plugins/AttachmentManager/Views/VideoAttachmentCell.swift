//
//  VideoAttachmentCell.swift
//  InputBarAccessoryView
//
//  Created by Samuel Folledo on 10/24/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit

open class VideoAttachmentCell: ImageAttachmentCell {
    
    // MARK: - Properties
    
    override open class var reuseIdentifier: String {
        return "VideoAttachmentCell"
    }
    
//    public let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
    public let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play-button.png"), for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Setup
    
    private func setup() {
        containerView.addSubview(imageView)
        imageView.fillSuperview()
        containerView.addSubview(playButton)
        playButton.fillSuperview()
    }
}
