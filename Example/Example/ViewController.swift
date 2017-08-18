//
//  ViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let textView = UITextView()
    let imageView = UIImageView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.addConstraints(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        imageView.backgroundColor = UIColor.groupTableViewBackground
        
        label.addConstraints(view.topAnchor, left: imageView.rightAnchor, bottom: imageView.bottomAnchor, right: view.rightAnchor, topConstant: 30, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        label.backgroundColor = UIColor.groupTableViewBackground
        
        textView.addConstraints(label.bottomAnchor, left: imageView.leftAnchor, bottom: nil, right: label.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300)
        textView.backgroundColor = UIColor.groupTableViewBackground
    }


}

