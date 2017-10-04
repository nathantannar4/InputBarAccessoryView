//
//  ViewController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class ViewController: UIViewController, InputBarAccessoryViewDelegate, AutocompleteDataSource {
    
    lazy var bar: InputBarAccessoryView = { [unowned self] in
        let bar = InputBarAccessoryView()
        bar.delegate = self
        
        // required to pass autocomplete strings to the manager
        bar.autocompleteManager.dataSource = self
        
        // default value is false
        bar.isAutocompleteEnabled = true
        return bar
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
        bar.textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        bar.textView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        bar.textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.textView.layer.borderWidth = 1.0
        bar.textView.layer.cornerRadius = 16.0
        bar.textView.layer.masksToBounds = true
        bar.textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
                self.bar.textView.text.append("@")
                
                // We must call checkLastCharacter() after because the previous append doesnt utilize the UITextView delegate that the autocomplete relies on
                self.bar.autocompleteManager.checkLastCharacter()
            },
            makeButton(named: "ic_hashtag").onSelected { _ in
                self.bar.textView.text.append("#")
                
                // We must call checkLastCharacter() after because the previous append doesnt utilize the UITextView delegate that the autocomplete relies on
                self.bar.autocompleteManager.checkLastCharacter()            },
            .flexibleSpace,
            makeButton(named: "ic_library").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
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
    
        // We can change the container insets if we want
        bar.textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.textView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    
        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        bar.setRightStackViewWidthConstant(to: 0, animated: viewIsLoaded)
        
        // Finally set the items
        bar.setStackViewItems(items, forStack: .bottom, animated: viewIsLoaded)
    }
    
    @objc
    func iMessage() {
        none()
        bar.textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bar.textView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        bar.textView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        bar.textView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        bar.textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        bar.textView.layer.borderWidth = 1.0
        bar.textView.layer.cornerRadius = 16.0
        bar.textView.layer.masksToBounds = true
        bar.textView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        bar.setRightStackViewWidthConstant(to: 38, animated: viewIsLoaded)
        bar.setStackViewItems([bar.sendButton, .fixedSpace(2)], forStack: .right, animated: viewIsLoaded)
        bar.sendButton.imageView?.backgroundColor = bar.tintColor
        bar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        bar.sendButton.setSize(CGSize(width: 36, height: 36), animated: viewIsLoaded)
        bar.sendButton.image = #imageLiteral(resourceName: "ic_up")
        bar.sendButton.title = nil
        bar.sendButton.imageView?.layer.cornerRadius = 16
        bar.sendButton.backgroundColor = .clear
        bar.textViewPadding.right = -38
    }
    
    @objc
    func none() {
        bar.textView.resignFirstResponder()
        let newBar = InputBarAccessoryView()
        newBar.delegate = self
        bar = newBar
        bar.autocompleteManager.dataSource = self
        bar.isAutocompleteEnabled = true
        reloadInputViews()
    }
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: viewIsLoaded)
            }.onSelected {
                $0.tintColor = UIColor.blue
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        label.text = text
        inputBar.textView.text = String()
    }
    
    func autocomplete(_ autocompleteManager: AutocompleteManager, autocompleteTextFor prefix: Character) -> [String] {
        
        var array: [String] = []
        for _ in 1...100 {
            if prefix == "@" {
                array.append(Randoms.randomFakeName().replacingOccurrences(of: " ", with: ".").lowercased())
            } else {
                array.append(Lorem.word())
            }
        }
        return array
    }
    
    func autocomplete(_ autocompleteManager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (char: Character, filterText: String, autocompleteText: String)) -> UITableViewCell {
        
        // The following is done by default if you do not override this function, you will need this if you implement your own `autocomplete(_ autocompleteManager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for arguments: (char: Character, filterText: String, autocompleteText: String)) -> UITableViewCell `
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            return UITableViewCell()
        }
        
        let matchingRange = (arguments.autocompleteText as NSString).range(of: arguments.filterText, options: .caseInsensitive)
        let attributedString = NSMutableAttributedString().normal(arguments.autocompleteText)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)], range: matchingRange)
        let stringWithPrefix = NSMutableAttributedString().normal(String(arguments.char))
        stringWithPrefix.append(attributedString)
        cell.textLabel?.attributedText = stringWithPrefix
        
        cell.backgroundColor = autocompleteManager.inputBarAccessoryView?.backgroundView.backgroundColor ?? .white
        cell.tintColor = autocompleteManager.inputBarAccessoryView?.tintColor
        cell.separatorLine.isHidden = indexPath.row == (autocompleteManager.currentAutocompleteText ?? []).count - 1
        
//        cell.imageView?.tintAdjustmentMode = .normal
//        cell.imageView?.image = UIImage(named: "ic_user")
//        cell.imageView?.backgroundColor = .lightGray
//        cell.imageView?.layer.borderColor = cell.tintColor.cgColor
//        cell.imageView?.layer.borderWidth = 1.5
//        cell.imageView?.layer.cornerRadius = 8
//        cell.imageView?.clipsToBounds = true
//        
//        if indexPath.row % 3 == 0 {
//            cell.detailTextLabel?.text = "Online"
//            cell.detailTextLabel?.textColor = UIColor(red: 76/255, green: 153/255, blue: 0, alpha: 1)
//        }
        
        return cell
    }
}

