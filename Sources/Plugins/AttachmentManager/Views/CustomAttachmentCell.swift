//
//  CustomAttachmentCell.swift
//  
//
//  Created by Bruno Antoninho on 08/06/2022.
//

import UIKit

open class CustomAttachmentCell: AttachmentCell {
    
    override open class var reuseIdentifier: String {
        return "CustomAttachmentCell"
    }
    
    // MARK: - Properties
    
    open lazy var attachmentImage: UIImageView = { [weak self] in
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "documentIcon")
        imageView.tintColor = UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
        return imageView
    }()
    
    open lazy var attachmentLabel: UILabel = { [weak self] in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var attachmentImageLayoutSet: NSLayoutConstraintSet?
    private var attachmentLabelLayoutSet: NSLayoutConstraintSet?
    
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
        attachmentLabel.text = ""
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        containerView.addSubview(attachmentImage)
        containerView.addSubview(attachmentLabel)
    }

    private func setupConstraints() {
        
        attachmentImageLayoutSet = NSLayoutConstraintSet(
            centerX: attachmentImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            centerY: attachmentImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -5),
            width: attachmentImage.widthAnchor.constraint(equalToConstant: 26),
            height: attachmentImage.heightAnchor.constraint(equalToConstant: 29)
        ).activate()
        
        attachmentLabelLayoutSet = NSLayoutConstraintSet(
            left: attachmentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            right: attachmentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            centerX: attachmentLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            centerY: attachmentLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 20)
        ).activate()
    }
}
