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
    
    
    let actionView = InputBarItem<UIButton>()
        .configure {
            $0.view.backgroundColor = .blue
        }.onTap { _ in 
            print("tapped")
    }
    let bar = InputBarAccessoryView()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return bar
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        view.addSubview(actionView.view)
        
        actionView.view.frame = CGRect(x: 20, y: 50, width: 100, height: 100)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.setSlack))
        actionView.view.addGestureRecognizer(tapGesture)
        
        bar.delegate = self
        bar.isTranslucent = true
        bar.textView.backgroundColor = .clear
        
        
//        setSimple()
//        setSlack()
    }
    
    func setSimple() {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        bar.textView.textContainerInset = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        bar.textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.textView.layer.borderWidth = 1.0
        bar.textView.layer.cornerRadius = 16.0
        bar.textView.layer.masksToBounds = true
        bar.textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.setLeftItem(button, size: CGSize(width: 36, height: 36), animated: false)
    }

    func setSlack() {
        func makeButton(named: String) -> UIButton {
            let button = UIButton()
            button.setImage(UIImage(named: named)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            return button
        }
        
        bar.textViewPadding = .zero
        
        bar.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        bar.stackView.addArrangedSubview(makeButton(named: "ic_camera"))
        bar.stackView.addArrangedSubview(makeButton(named: "ic_library"))
        bar.stackView.addArrangedSubview(makeButton(named: "ic_at"))
        bar.stackView.addArrangedSubview(makeButton(named: "ic_hashtag"))
        
        // Spacer view
        bar.stackView.addArrangedSubview(UIView())
        
        let button = bar.sendButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 52).isActive = true
        bar.stackView.addArrangedSubview(button)
        
        bar.setRightItem(nil, animated: true)
        bar.setStackViewHeight(20, animated: true)
        
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            inputBar.setLeftItemSize(CGSize(width: 0, height: 36), animated: true)
        } else {
            inputBar.setLeftItemSize(CGSize(width: 36, height: 36), animated: true)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSelectSendButtonWith text: String) {
        print(text)
        inputBar.textView.text = String()
        self.inputBar(inputBar, textViewDidChangeTo: String())
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewDidChangeTo text: String) {
        for subview in inputBar.stackView.arrangedSubviews {
            if let sendButton = subview as? InputBarSendButton {
                sendButton.isEnabled = !text.isEmpty
            }
        }
    }
}

