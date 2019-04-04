//
//  InputBarStyleSelectionController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2019 Nathan Tannar. All rights reserved.
//

import UIKit

class InputBarStyleSelectionController: UITableViewController {
    
    let styles = InputBarStyle.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = "InputBarAccessoryView"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Styles", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "InputBarViewController"
        }
        return section == 1 ? "InputAccessoryView" : "Subview"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            cell.textLabel?.text = "README Preview"
        } else {
            cell.textLabel?.text = styles[indexPath.row].rawValue
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            navigationController?.pushViewController(READMEPreviewViewController(), animated: true)
        } else {
            let convo = SampleData.shared.getConversations(count: 1)[0]
            if indexPath.section == 1 {
                navigationController?.pushViewController(
                    InputAccessoryExampleViewController(style: styles[indexPath.row],
                                                        conversation: convo),
                    animated: true)
            } else if indexPath.section == 2 {
                navigationController?.pushViewController(
                    SubviewExampleViewController(style: styles[indexPath.row],
                                                 conversation: convo),
                    animated: true)
            }
        }
    }
}
