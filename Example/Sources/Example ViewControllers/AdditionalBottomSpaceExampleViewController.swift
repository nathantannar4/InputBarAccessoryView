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
            if let windowBottomInset = UIWindowScene.activeScene?.windows.first?.safeAreaInsets.bottom,
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.inputBar.inputTextView.becomeFirstResponder()
    }
}

private extension UIWindowScene {
    static var activeScene: UIWindowScene? {
        let connectedScenes = UIApplication.shared.connectedScenes
        if connectedScenes.count > 1 {
            return connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        } else {
            return connectedScenes.first as? UIWindowScene
        }
    }
}
