//
//  SampleData.swift
//  Example
//
//  Created by Nathan Tannar on 2/6/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class SampleData {
    
    class Conversation {
        
        let title: String
        
        var messages: [Message]
        
        var users: [User]
        
        var lastMessage: Message? { return messages.last }
        
        init(users: [User], messages: [Message]) {
            self.users = users
            self.messages = messages
            self.title = Lorem.words(nbWords: 4).capitalized
        }
    }
    
    class Message {
        
        let text: String
        let user: User
        
        init(user: User, text: String) {
            self.user = user
            self.text = text
        }
    }
    
    class User {
        
        let id: String = UUID().uuidString
        let image: UIImage
        let name: String
        
        init(name: String, image: UIImage) {
            self.image = image
            self.name = name
        }
    }
    
    static var shared = SampleData()
    
    let users = [User(name: "Avatar", image: #imageLiteral(resourceName: "avatar")), User(name: "Ninja", image: #imageLiteral(resourceName: "ninja")), User(name: "Anonymous", image: #imageLiteral(resourceName: "anonymous")), User(name: "Rick Sanchez", image: #imageLiteral(resourceName: "rick")), User(name: "Nathan Tannar", image: #imageLiteral(resourceName: "nathan"))]
    
    var currentUser: User { return users.last! }
    
    private init() {}
    
    func getConversations(count: Int) -> [Conversation] {
        
        var conversations = [Conversation]()
        for _ in 0..<count {
            
            var messages = [Message]()
            for i in 0..<30 {
                let user = users[i % users.count]
                if i % 2 == 0 {
                    let message = Message(user: user, text: Lorem.sentence())
                    messages.append(message)
                } else {
                    let message = Message(user: user, text: Lorem.paragraph())
                    messages.append(message)
                }
            }
            let newConversation = Conversation(users: users, messages: messages)
            conversations.append(newConversation)
        }
        return conversations
    }
}
