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
        let buttonImage = UIImage(named: "play-button.png")!.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            playButton.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
}
