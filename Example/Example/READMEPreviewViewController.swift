//
//  READMEPreviewViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2018-11-16.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

final class READMEPreviewViewController: InputBarViewController {

    lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
        manager.delegate = self
        manager.dataSource = self
        manager.maxSpaceCountDuringCompletion = 1
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        inputBar.inputTextView.autocorrectionType = .no
        inputBar.inputTextView.autocapitalizationType = .none
        inputBar.inputTextView.keyboardType = .twitter
        let size = UIFont.preferredFont(forTextStyle: .body).pointSize
        autocompleteManager.register(prefix: "@", with: [.font: UIFont.preferredFont(forTextStyle: .body),.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),.backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)])
        autocompleteManager.register(prefix: "#", with: [.font: UIFont.boldSystemFont(ofSize: size)])
        inputBar.inputPlugins = [autocompleteManager]
    }

    override func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        setStateSending()
        DispatchQueue.global(qos: .background).async { [weak self] in
            sleep(2)
            DispatchQueue.main.async { [weak self] in
                self?.setStateReady()
            }
        }
    }

    private func setStateSending() {
        inputBar.inputTextView.text = ""
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.isEditable = false
        inputBar.sendButton.startAnimating()
    }

    private func setStateReady() {
        inputBar.inputTextView.text = ""
        inputBar.inputTextView.placeholder = "Aa"
        inputBar.inputTextView.isEditable = true
        inputBar.sendButton.stopAnimating()
    }
}

extension READMEPreviewViewController: AutocompleteManagerDelegate, AutocompleteManagerDataSource {

    // MARK: - AutocompleteManagerDataSource

    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion] {

        if prefix == "@" {
            let name = SampleData.shared.currentUser.name
                .lowercased().replacingOccurrences(of: " ", with: ".")
            return [AutocompleteCompletion(text: name)]
        } else {
            return ["InputBarAccessoryView", "iOS"].map { AutocompleteCompletion(text: $0) }
        }
    }

    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("Oops, some unknown error occurred")
        }
        if session.prefix == "@" {
            let user = SampleData.shared.currentUser
            cell.imageView?.image = user.image
            cell.imageViewEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            cell.imageView?.layer.cornerRadius = 8
            cell.imageView?.layer.borderWidth = 1
            cell.imageView?.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).cgColor
            cell.imageView?.layer.masksToBounds = true
        }
        cell.textLabel?.attributedText = manager.attributedText(matching: session, fontSize: 15, keepPrefix: session.prefix == "#" )
        return cell
    }

    // MARK: - AutocompleteManagerDelegate

    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }

    // MARK: - AutocompleteManagerDelegate Helper

    func setAutocompleteManager(active: Bool) {
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.insertArrangedSubview(autocompleteManager.tableView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.removeArrangedSubview(autocompleteManager.tableView)
            topStackView.layoutIfNeeded()
        }
        inputBar.invalidateIntrinsicContentSize()
    }
}
