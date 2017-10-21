//
//  ViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class ViewController: UIViewController, InputBarAccessoryViewDelegate, AutocompleteManagerDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var bar: InputBarAccessoryView = { [weak self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        return bar
    }()
    
    /// The object that manages attachments
    open lazy var attachmentManager: AttachmentManager = { [weak self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()

    /// The object that manages autocomplete
    open lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.bar.inputTextView)
        manager.delegate = self
        manager.dataSource = self
        manager.autocompletePrefixes = ["@","#",":"]
        return manager
    }()
    
    // Required to use an inputAccessoryView
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // Required to use an inputAccessoryView
    override var inputAccessoryView: UIView? {
        return bar
    }
    
    // We only want to adjust animate changes in the bar when the view is loaded
    var viewIsLoaded = false
    
    var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "InputBarAccessoryView"
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        bar.inputManagers = [attachmentManager, autocompleteManager]
        
        let imageView = UIImageView(image: UIImage(named: "NT Logo Blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "ic_keyboard"),
                            style: .plain,
                            target: self,
                            action: #selector(handleKeyboardButton))
        ]
        
        viewIsLoaded = true
    }
    
    @objc
    func handleKeyboardButton() {
        
        let actionSheetController = UIAlertController(title: "Change Keyboard Style", message: nil, preferredStyle: .actionSheet)
        let actions = [
            UIAlertAction(title: "Slack", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.slack()
                })
            }),
            UIAlertAction(title: "iMessage", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.iMessage()
                })
            }),
            UIAlertAction(title: "Facebook Messenger", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.messenger()
                })
            }),
            UIAlertAction(title: "Default", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.none()
                })
            }),
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ]
        actions.forEach { actionSheetController.addAction($0) }
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc
    func messenger() {
        none()
        let button = InputBarButtonItem()
        button.onKeyboardSwipeGesture { item, gesture in
            if gesture.direction == .left {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
            } else if gesture.direction == .right {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
            }
        }
        button.setSize(CGSize(width: 36, height: 36), animated: viewIsLoaded)
        button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        bar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        bar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.inputTextView.layer.borderWidth = 1.0
        bar.inputTextView.layer.cornerRadius = 16.0
        bar.inputTextView.layer.masksToBounds = true
        bar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.setLeftStackViewWidthConstant(to: 36, animated: viewIsLoaded)
        bar.setStackViewItems([button], forStack: .left, animated: viewIsLoaded)
    }

    @objc
    func slack() {
        none()
        let items = [
            makeButton(named: "ic_camera").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            },
            makeButton(named: "ic_at").onSelected { _ in
                self.autocompleteManager.handleInput(of: "@" as AnyObject)
            },
            makeButton(named: "ic_hashtag").onSelected { _ in
                self.autocompleteManager.handleInput(of: "#" as AnyObject)
            },
            .flexibleSpace,
            makeButton(named: "ic_library")
                .configure {
                    $0.tintColor = .red
                }.onSelected {
                    $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            },
            bar.sendButton
                .configure {
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1.5
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.setTitleColor(.white, for: .normal)
                    $0.setTitleColor(.white, for: .highlighted)
                    $0.setSize(CGSize(width: 52, height: 30), animated: viewIsLoaded)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = .white
                }.onEnabled {
                    $0.backgroundColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    // We use a transform becuase changing the size would cause the other views to relayout
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        items.forEach { $0.tintColor = .lightGray }
        
//        attachmentManager.isPersistent = true //to always display the AttachmentView
        
        // We can change the container insets if we want
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    
        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        bar.setRightStackViewWidthConstant(to: 0, animated: viewIsLoaded)
        
        // Finally set the items
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)
    }
    
    @objc
    func iMessage() {
        none()
        bar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        bar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        bar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.inputTextView.layer.borderWidth = 1.0
        bar.inputTextView.layer.cornerRadius = 16.0
        bar.inputTextView.layer.masksToBounds = true
        bar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.setRightStackViewWidthConstant(to: 38, animated: viewIsLoaded)
        bar.setStackViewItems([bar.sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: viewIsLoaded)
        bar.sendButton.imageView?.backgroundColor = bar.tintColor
        bar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        bar.sendButton.setSize(CGSize(width: 36, height: 36), animated: viewIsLoaded)
        bar.sendButton.image = #imageLiteral(resourceName: "ic_up")
        bar.sendButton.title = nil
        bar.sendButton.imageView?.layer.cornerRadius = 16
        bar.sendButton.backgroundColor = .clear
        bar.inputTextViewPadding.right = -38
    }
    
    @objc
    func none() {
        bar.inputTextView.resignFirstResponder()
        bar.inputManagers.removeAll()
        let newBar = InputBarAccessoryView()
        newBar.delegate = self
        autocompleteManager = AutocompleteManager(for: newBar.inputTextView)
        autocompleteManager.delegate = self
        autocompleteManager.dataSource = self
        newBar.inputManagers = [autocompleteManager, attachmentManager]
        bar = newBar
        reloadInputViews()
    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: viewIsLoaded)
            }.onSelected {
                $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        label.text = text
        
        inputBar.inputTextView.text = String()
    }
    
    
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteTextFor prefix: Character) -> [String] {
        
        var array: [String] = []
        for _ in 1...100 {
            if prefix == "@" {
                array.append(Randoms.randomFakeName().replacingOccurrences(of: " ", with: ".").lowercased())
            } else if prefix == "#" {
                array.append(Lorem.word())
            }
        }
        return array
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, replacementTextFor arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> String {
        
        // custom replacement text, the default returns is shown below
        return String(arguments.prefix) + arguments.autocompleteText
    }
    
    // This is only needed to override the default cell
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (prefix: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
       
        let cell = manager.defaultCell(in: tableView, at: indexPath, for: arguments)
        
        // or provide your own logic
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.attachmentManager.handleInput(of: pickedImage)
            }
        })
    }
}

extension ViewController: AttachmentManagerDelegate {
    
    open func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    open func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AnyObject]) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    open func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AnyObject, at index: Int) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    open func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AnyObject, at index: Int) {
        bar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    open func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Attempts to activate/deactive the AttachmentManager by inserting/removing it into the top UIStackView
    ///
    /// - Parameter active: If the manager should be activated
    open func setAttachmentManager(active: Bool) {
        
        let topStackView = bar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            let index = topStackView.arrangedSubviews.count
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: index)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

extension ViewController: AutocompleteManagerDelegate {
    
    open func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }
    
    /// Attempts to activate/deactive the AutocompleteManager by inserting/removing it into the top UIStackView. Also inserts/removes a SeparatorLine below it
    ///
    /// - Parameter active: If the manager should be activated
    open func setAutocompleteManager(active: Bool) {
        
        let topStackView = bar.topStackView
        if active && !topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.insertArrangedSubview(autocompleteManager.tableView, at: 1)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.removeArrangedSubview(autocompleteManager.tableView)
            topStackView.layoutIfNeeded()
        }
    }
}
