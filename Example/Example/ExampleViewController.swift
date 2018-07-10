//
//  ExampleViewController.swift
//  InputBarAccessoryView Example
//
//  Copyright © 2017-2018 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 10/4/17.
//

import UIKit
import InputBarAccessoryView

enum KeyboardExamples: String {
    case imessage = "iMessage"
    case slack = "Slack"
    case githawk = "GitHawk"
    case facebook = "Facebook"
    case `default` = "Default"
    
    func createBar() -> InputBarAccessoryView {
        switch self {
            case .imessage: return iMessageInputBar()
            case .slack: return SlackInputBar()
            case .githawk: return GitHawkInputBar()
            case .facebook: return FacebookInputBar()
            case .default: return InputBarAccessoryView()
        }
    }
}

class ExampleViewController: UITableViewController {
    
    // Required to use an inputAccessoryView
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // Required to use an inputAccessoryView
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    lazy var inputBar: InputBarAccessoryView = { [weak self] in
        let inputBar = InputBarAccessoryView()
        inputBar.delegate = self
        return inputBar
    }()
    
    open lazy var typingIdicator: TypingIndicator = { [weak self] in
        let view = TypingIndicator()
        view.delegate = self
        return view
    }()
    
    /// The object that manages attachments
    open lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()

    /// The object that manages autocomplete
    open lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
        manager.delegate = self
        manager.dataSource = self
        return manager
    }()
    
    var usersTyping = 0
    
    var conversation: SampleData.Conversation
    
    var hastagAutocompletes: [AutocompleteCompletion] = {
        var array: [AutocompleteCompletion] = []
        for _ in 1...100 {
            array.append(AutocompleteCompletion(Lorem.word()))
        }
        return array
    }()
    
    // Completions loaded async that get appeneded to local cached completions
    var asyncCompletions: [AutocompleteCompletion] = []
    
    init(conversation: SampleData.Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.keyboardDismissMode = .interactive
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_keyboard"),
                            style: .plain,
                            target: self,
                            action: #selector(handleKeyboardButton)),
            UIBarButtonItem(image: UIImage(named: "ic_typing"),
                            style: .plain,
                            target: self,
                            action: #selector(handleTypingButton))
        ]
        
        inputBar.delegate = self
        autocompleteManager = AutocompleteManager(for: inputBar.inputTextView)
        autocompleteManager.delegate = self
        autocompleteManager.dataSource = self
        autocompleteManager.register(prefix: "@", with: [.font: UIFont.preferredFont(forTextStyle: .body),.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),.backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)])
        autocompleteManager.register(prefix: "#")
        inputBar.inputPlugins = [autocompleteManager, attachmentManager]
        inputBar.setStackViewItems([typingIdicator], forStack: .top, animated: false)
        
        // RTL Support
//        autocompleteManager.paragraphStyle.baseWritingDirection = .rightToLeft
//        inputBar.inputTextView.textAlignment = .right
//        inputBar.inputTextView.placeholderLabel.textAlignment = .right
    }
    
    @objc
    func handleTypingButton() {
        
        usersTyping += 1
        switch usersTyping {
        case 1:
            typingIdicator.setUsersTyping(to: [conversation.users[0].name])
        case 2:
            typingIdicator.setUsersTyping(to: [conversation.users[0].name, conversation.users[1].name])
        case 3:
            typingIdicator.setUsersTyping(to: [conversation.users[0].name, conversation.users[1].name, conversation.users[2].name])
        default:
            typingIdicator.setUsersTyping(to: [])
            usersTyping = 0
        }
    }
    
    @objc
    func handleKeyboardButton() {
        
        let actionSheetController = UIAlertController(title: "Change Keyboard Style", message: nil, preferredStyle: .actionSheet)
        let keyboards: [KeyboardExamples] = [.imessage, .slack, .facebook, .githawk, .default]
        for keyboard in keyboards {
            actionSheetController.addAction(UIAlertAction(title: keyboard.rawValue, style: .default, handler: { [weak self] (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self?.setKeyboardStyle(keyboard)
                })
            }))
        }
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func setKeyboardStyle(_ style: KeyboardExamples) {
        
        // Flush old
        inputBar.inputTextView.resignFirstResponder()
        inputBar.inputPlugins.removeAll()
        resignFirstResponder()
        
        let newBar = style.createBar()
        newBar.delegate = self
        autocompleteManager = AutocompleteManager(for: newBar.inputTextView)
        autocompleteManager.delegate = self
        autocompleteManager.dataSource = self
        autocompleteManager.register(prefix: "@", with: [.font: UIFont.preferredFont(forTextStyle: .body),.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),.backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)])
        autocompleteManager.register(prefix: "#")
        newBar.inputPlugins = [autocompleteManager, attachmentManager]
        newBar.setStackViewItems([typingIdicator], forStack: .top, animated: false)
        inputBar = newBar
        reloadInputViews()
        becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = conversation.messages[indexPath.row].user.image
        cell.imageView?.layer.cornerRadius = 5
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = conversation.messages[indexPath.row].user.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.text = conversation.messages[indexPath.row].text
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
}

extension ExampleViewController: InputBarAccessoryViewDelegate {
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        conversation.messages.append(SampleData.Message(user: SampleData.shared.currentUser, text: text))
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        let indexPath = IndexPath(row: conversation.messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
//        inputBar.inputTextView.setBaseWritingDirection(.rightToLeft, for: inputBar.inputTextView.textRange(from: inputBar.inputTextView.beginningOfDocument, to: inputBar.inputTextView.endOfDocument)!)
        
        guard autocompleteManager.currentSession != nil else { return }
        // Load some data asyncronously for the given session.prefix
        DispatchQueue.global(qos: .default).async {
            // fake background loading task
            var array: [AutocompleteCompletion] = []
            for _ in 1...10 {
                array.append(AutocompleteCompletion(Lorem.word()))
            }
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.asyncCompletions = array
                self?.autocompleteManager.reloadData()
            }
        }
    }
    
}

extension ExampleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
}

extension ExampleViewController: TypingIndicatorDelegate {
    
    func typingIndicator(_ typingIndicator: TypingIndicator, currentUserIsTyping isTyping: Bool) {
        print("Current User isTyping: \(isTyping)")
    }
    
}

extension ExampleViewController: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

extension ExampleViewController: AutocompleteManagerDelegate, AutocompleteManagerDataSource {
    
    // MARK: - AutocompleteManagerDataSource
    
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion] {
        
        if prefix == "@" {
            return conversation.users
                .filter { $0.name != SampleData.shared.currentUser.name }
                .map { AutocompleteCompletion($0.name) } + asyncCompletions
        } else if prefix == "#" {
            return hastagAutocompletes + asyncCompletions
        }
        return []
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("Oops, some unknown error occurred")
        }
        let users = SampleData.shared.users
        let name = session.completion?.text ?? ""
        let user = users.filter { return $0.name == name }.first
        cell.imageView?.image = user?.image
        cell.textLabel?.attributedText = manager.attributedText(matching: session, fontSize: 15)
        return cell
    }
    
    // MARK: - AutocompleteManagerDelegate
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldRegister prefix: String, at range: NSRange) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldUnregister prefix: String) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldComplete prefix: String, with text: String) -> Bool {
        return true
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
