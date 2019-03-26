//
//  SubviewExampleViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2019 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

final class SubviewExampleViewController: CommonTableViewController {
    
    // MARK: - Properties
    
    private var keyboardManager = KeyboardManager()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(inputBar)
        
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
        
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = barHeight + notification.endFrame.height
            self?.tableView.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableView.contentInset.bottom = barHeight
                self?.tableView.scrollIndicatorInsets.bottom = barHeight
        }
    }
    
}
