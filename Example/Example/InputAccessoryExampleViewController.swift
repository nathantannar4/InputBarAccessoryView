//
//  InputAccessoryExampleViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2019 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

final class InputAccessoryExampleViewController: CommonTableViewController {
    
    // MARK: - Properties
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
