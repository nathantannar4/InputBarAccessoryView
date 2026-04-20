//
//  GlassInputBar.swift
//  Example
//
//  Created by Nathan Tannar on 2026-04-20.
//  Copyright © 2026 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

final class GlassInputBar: InputBarAccessoryView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = nil
        separatorLine.isHidden = true
        if #available(iOS 26.0, *) {
            let container = UIGlassContainerEffect()
            container.spacing = 8
            containerContentView.effect = container
            backgroundView.backgroundColor = nil

            middleContentViewPadding.left = 8
            middleContentViewPadding.right = 8

            let effect = UIGlassEffect(style: .regular)
            effect.isInteractive = true
            middleContentViewWrapper.cornerConfiguration = .capsule(maximumRadius: 20)
            middleContentViewWrapper.effect = effect

            leftContentView.cornerConfiguration = .capsule(maximumRadius: 20)
            leftContentView.effect = effect

            rightContentView.cornerConfiguration = .capsule(maximumRadius: 20)
            rightContentView.effect = effect
        }

        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemBlue

        setLeftStackViewWidthConstant(to: 36, animated: false)
        setStackViewItems([button], forStack: .left, animated: false)
    }
}

