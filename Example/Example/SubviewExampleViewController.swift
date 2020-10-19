//
//  SubviewExampleViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2020 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

final class SubviewExampleViewController: CommonTableViewController {
    
    // MARK: - Properties

    private let keyboardManager = KeyboardManager()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(inputBar)
        
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
    }
    
}
