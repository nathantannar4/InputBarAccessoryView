//
//  TypingIndicatorDelegate.swift
//  InputBarAccessoryView
//
//  Created by Nathan Tannar on 2/11/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import Foundation

public protocol TypingIndicatorDelegate: class {
    
    /// Indicates if the current user should be broadcasting a 'typing' indicator to
    /// the server
    ///
    /// - Parameters:
    ///   - typingIndicator: The `TypingIndicator` object
    ///   - isTyping: If the current user is typing
    func typingIndicator(_ typingIndicator: TypingIndicator, currentUserIsTyping isTyping: Bool)
    
}
