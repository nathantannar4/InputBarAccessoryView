//
//  ButtonAnimationExample.swift
//  Example
//
//  Created by Andrew Breckenridge on 9/24/20.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class ButtonAnimationExample: InputAccessoryExampleViewController {

    var isShowingSendButton: Bool = true {
        didSet {
            if oldValue != isShowingSendButton {
                inputBar.sendButton.frame.origin.y = inputBar.rightStackView.frame.height / 2
                self.inputBar.sendButton.setSize(isShowingSendButton ? CGSize(width: 38, height: 38) : .zero, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.inputBar.shouldManageSendButtonEnabledState = false

        isShowingSendButton = false
    }

    override func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        self.isShowingSendButton = !text.isEmpty
    }
}
