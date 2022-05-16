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

        keyboardManager.shouldApplyAdditionBottomSpaceToInteractiveDismissal = true
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar, withAdditionalBottomSpace: {
            return 0
            return -self.view.safeAreaInsets.bottom
            return -(self.inputBar.frame.height + self.view.safeAreaInsets.bottom)
        })
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// This replicates instagram's behavior when commenting in a post. As of 2020-09, it appears like they have one of the best product experiences of this handling the keyboard when dismissing the UIViewController
        self.inputBar.inputTextView.resignFirstResponder()
        /// This is set because otherwise, if only partially dragging the left edge of the screen, and then cancelling the dismissal, on viewDidAppear UIKit appears to set the first responder back to the inputTextView (https://stackoverflow.com/a/41847448)
        self.inputBar.inputTextView.canBecomeFirstResponder = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// The opposite of `viewWillDisappear(_:)`
        self.inputBar.inputTextView.canBecomeFirstResponder = true
        self.inputBar.inputTextView.becomeFirstResponder()
    }
    
}
