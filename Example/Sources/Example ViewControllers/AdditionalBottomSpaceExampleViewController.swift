//
//  AdditionalBottomSpaceExampleViewController.swift
//  Example
//
//  Created by Martin Púčik on 16.05.2022.
//  Copyright © 2022 Nathan Tannar. All rights reserved.
//

import Foundation
import UIKit
import InputBarAccessoryView

final class AdditionalBottomSpaceExampleViewController: CommonTableViewController {

    private lazy var keyboardManager = KeyboardManager()

    private lazy var additionalBottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(inputBar)
        view.addSubview(additionalBottomBar)

        NSLayoutConstraint.activate([
            additionalBottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            additionalBottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            additionalBottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            additionalBottomBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.layoutIfNeeded()

        keyboardManager.additionalInputViewBottomConstraintConstant = {
            var safeBottomInset: CGFloat = self.view.safeAreaInsets.bottom
            if let windowBottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom,
               safeBottomInset != windowBottomInset {
                safeBottomInset = windowBottomInset
            }
            return -(self.additionalBottomBar.frame.height + safeBottomInset)
        }

        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)

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
