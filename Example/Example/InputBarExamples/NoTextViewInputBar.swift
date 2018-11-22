//
//  NoTextViewInputBar.swift
//  Example
//
//  Created by Nathan Tannar on 2018-11-21.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class NoTextViewInputBar: InputBarAccessoryView {

    let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join Chat", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        joinButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        setStackViewItems([], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 0, animated: false)
        setMiddleContentView(joinButton, animated: false)

        joinButton.addTarget(self, action: #selector(joinPressed), for: .touchUpInside)
    }

    @objc func joinPressed() {
        setMiddleContentView(inputTextView, animated: false)
        setStackViewItems([sendButton], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 52, animated: false)
    }
}

