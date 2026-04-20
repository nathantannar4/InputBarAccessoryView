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
            backgroundView.effect = UIGlassContainerEffect()
            backgroundView.backgroundColor = nil

            let effect = UIGlassEffect(style: .regular)
            effect.isInteractive = true
            contentView.cornerConfiguration = .capsule()
            contentView.effect = effect
        }

        
    }
}

