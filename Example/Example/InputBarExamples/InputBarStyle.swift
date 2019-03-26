//
//  InputBarStyle.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2019 Nathan Tannar. All rights reserved.
//

import Foundation
import InputBarAccessoryView

enum InputBarStyle: String, CaseIterable {
    
    case imessage = "iMessage"
    case slack = "Slack"
    case githawk = "GitHawk"
    case facebook = "Facebook"
    case noTextView = "No InputTextView"
    case `default` = "Default"
    
    func generate() -> InputBarAccessoryView {
        switch self {
        case .imessage: return iMessageInputBar()
        case .slack: return SlackInputBar()
        case .githawk: return GitHawkInputBar()
        case .facebook: return FacebookInputBar()
        case .noTextView: return NoTextViewInputBar()
        case .default: return InputBarAccessoryView()
        }
    }
}
