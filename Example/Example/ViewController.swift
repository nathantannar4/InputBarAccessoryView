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
    
    let textView = UITextView()
    let imageView = UIImageView()
    let label = UILabel()
    let bar = InputBarAccessoryView()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return bar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(imageView)
        view.addSubview(label)
        
        bar.delegate = self
        
        imageView.addConstraints(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        imageView.backgroundColor = UIColor.groupTableViewBackground
        
        label.addConstraints(view.topAnchor, left: imageView.rightAnchor, bottom: imageView.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        label.backgroundColor = UIColor.groupTableViewBackground
        
        textView.addConstraints(label.bottomAnchor, left: imageView.leftAnchor, bottom: nil, right: label.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        textView.backgroundColor = UIColor.groupTableViewBackground
        
//        let buttonItem = InputBarItem<UIButton>()
//            .configure {
//                $0.view.backgroundColor = .red
//                $0.view.setTitle("Button", for: .normal)
//                print("Button Setup")
//            }.onTap {
//                $0.view.backgroundColor = .blue
//                print("Button Tapped")
//        }
//        view.addSubview(buttonItem.view)
//        buttonItem.view.addConstraints(textView.bottomAnchor, left: textView.leftAnchor, bottom: nil, right: textView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            let button = UIButton(type: UIButtonType.contactAdd)
//            button.contentVerticalAlignment = .center
//            button.contentHorizontalAlignment = .center
//            self.bar.setRightItem(button, animated: true)
//        }
    }


    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            inputBar.setLeftItemSize(CGSize.zero, animated: true)
        } else {
            inputBar.setLeftItemSize(CGSize(width: 100, height: 36), animated: true)
        }
    }
}

