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
    
    public let durationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private let durationLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    public let playButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "play-button.png")!.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
        durationLabel.text = ""
    }
    
    // MARK: - Setup
    
    private func setup() {
        containerView.addSubview(imageView)
        imageView.fillSuperview()
        
        containerView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            playButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
        ])
        
        containerView.addSubview(durationLabelContainer)
        NSLayoutConstraint.activate([
            durationLabelContainer.heightAnchor.constraint(equalToConstant: 22),
            durationLabelContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            durationLabelContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            durationLabelContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        durationLabelContainer.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: durationLabelContainer.topAnchor, constant: 4),
            durationLabel.bottomAnchor.constraint(equalTo: durationLabelContainer.bottomAnchor, constant: -8),
            durationLabel.leadingAnchor.constraint(equalTo: durationLabelContainer.leadingAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: durationLabelContainer.trailingAnchor, constant: -8),
        ])
    }
}
