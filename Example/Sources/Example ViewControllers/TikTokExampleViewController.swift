//
//  TikTokExampleViewController.swift
//  Example
//
//  Created by 乐升平 on 2025/3/23.
//  Copyright © 2025 Nathan Tannar. All rights reserved.
//

import UIKit

class TikTokExampleViewController: CommonTableViewController {
    
    // MARK: - Properties
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure AutocompleteManager
        autocompleteManager.allowsConsecutiveMentions = true
        autocompleteManager.collectionView.scrollDirection = .horizontal
        autocompleteManager.collectionView.itemSize = CGSize(width: 90, height: 80)
    }
    

}
