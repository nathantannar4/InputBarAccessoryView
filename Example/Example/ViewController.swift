//
//  ViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import NTInputAccessoryView

class ViewController: UIViewController, InputBarAccessoryViewDelegate {
    
    enum Style: String {
        case slack = "Slack"
        case messenger = "Messenger"
        case whatsapp = "WhatsApp"
        case snapchat = "Snapchat"
        case imessage = "iMessage"
        case none = "None"
        
        func image() -> UIImage? {
            switch self {
            case .slack:
                return #imageLiteral(resourceName: "icons8-slack")
            case .messenger:
                return #imageLiteral(resourceName: "icons8-facebook_messenger")
            case .whatsapp:
                return #imageLiteral(resourceName: "icons8-whatsapp")
            case .snapchat:
                return #imageLiteral(resourceName: "icons8-snapchat")
            case .imessage:
                return #imageLiteral(resourceName: "imessage-logo-618x350")
            case .none:
                return nil
            }
        }
        
        static func all() -> [Style] {
            return [.slack, .messenger, .whatsapp, .snapchat, .imessage, .none]
        }
    }
    
    var currentStyle: Style = .none {
        didSet {
            title = currentStyle.rawValue
        }
    }
    
    lazy var bar: InputBarAccessoryView = { [unowned self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        return bar
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return bar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
        func createButton(withStyle style: Style) -> UIButton {
            let button = UIButton()
            button.setImage(style.image(), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: Selector(style.rawValue), for: .touchUpInside)
            switch style {
            case .snapchat:
                button.backgroundColor = UIColor.yellow
            case .none:
                button.setTitle("None", for: .normal)
                button.backgroundColor = UIColor.groupTableViewBackground
            default:
                button.backgroundColor = UIColor.groupTableViewBackground
            }
            return button
        }
        let buttons = Style.all().map { (style) -> UIButton in
            return createButton(withStyle: style)
        }
        var frame = CGRect(x: 16, y: 30, width: 50, height: 50)
        for button in buttons {
            button.frame = frame
            view.addSubview(button)
            frame.origin.x += 58
        }
        
    }
    
    func Messenger() {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        bar.textView.textContainerInset = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        bar.textView.placeholderLabelInsets = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 12)
        bar.textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.textView.layer.borderWidth = 1.0
        bar.textView.layer.cornerRadius = 16.0
        bar.textView.layer.masksToBounds = true
        bar.textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.setLeftItem(button, size: CGSize(width: 36, height: 36), animated: false)
    }

    func Slack() {
        func makeButton(named: String) -> InputBarItem {
            let button = InputBarItem()
                .configure {
                    $0.setImage(UIImage(named: named)?.withRenderingMode(.alwaysTemplate), for: .normal)
                    $0.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
                    $0.inputBarAccessoryView = bar
                    $0.size = CGSize(width: 20, height: 20)
                }.onTouchUpInside {
                    print($0)
            }
            return button
        }
        
        bar.textViewPadding = .zero
        
        let button = bar.sendButton().configure{
                $0.isEnabled = false
            $0.contentHorizontalAlignment = .right
        }
        
        
        let items = [
            makeButton(named: "ic_camera"),
            makeButton(named: "ic_library"),
            makeButton(named: "ic_at"),
            makeButton(named: "ic_hashtag"),
            .flexibleSpace,
            button
        ]
        
        bar.setStackViewItems(items, animated: true)
        bar.setRightItem(nil, animated: true)
    }
    
    func WhatsApp() {
        
    }
    
    func Snapchat() {
        
    }
    
    func iMessage() {
        
    }
    
    func None() {
        bar.textViewPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        bar.setStackViewItems([], animated: true)
        bar.setRightItem(bar.sendButton(), animated: true)
        bar.setLeftItem(nil, animated: true)
    }
    
    // MARK: - InputBarAccessoryViewDelegate

    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left && currentStyle == .messenger {
            inputBar.setLeftItemSize(CGSize(width: 0, height: 36), animated: true)
        } else if gesture.direction == .right && currentStyle == .messenger {
            inputBar.setLeftItemSize(CGSize(width: 36, height: 36), animated: true)
        } else if gesture.direction == .down {
            inputBar.textView.resignFirstResponder()
        } else {
            inputBar.textView.becomeFirstResponder()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSelectSendButtonWith text: String) {
        print(text)
        inputBar.textView.text = String()
        self.inputBar(inputBar, textViewTextDidChangeTo: String())
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        for subview in inputBar.stackView.arrangedSubviews {
            if let sendButton = subview as? InputBarSendButton {
                sendButton.isEnabled = !text.isEmpty
            }
        }
    }
}

