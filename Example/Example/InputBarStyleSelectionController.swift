//
//  InputBarStyleSelectionController.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2020 Nathan Tannar. All rights reserved.
//

import UIKit
import SwiftUI

class InputBarStyleSelectionController: UITableViewController {
    
    let styles = InputBarStyle.allCases

    let tabBarExampleIndexPath = IndexPath(row: 6, section: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = "InputBarAccessoryView"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Styles", style: .plain, target: nil, action: nil)
        if #available(iOS 13, *) {
            navigationController?.navigationBar.tintColor = .systemBackground
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        } else {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        navigationController?.navigationBar.barTintColor = .systemBlue
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return [
            0: "InputBarViewController",
            1: "InputAccessoryView",
            2: "Subview",
            3: "FAQ/Community Examples"
        ][section]!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     return 1
        case 1...2: return styles.count
        case 3:     return 3
        default:    fatalError("unknown section \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, _):        cell.textLabel?.text = "README Preview"
        case (1...2, _):    cell.textLabel?.text = styles[indexPath.row].rawValue
        case (3, 0):        cell.textLabel?.text = "Tab bar example (Slack style)"
        case (3, 1):        cell.textLabel?.text = "Send button animations"
        case (3, 2):        cell.textLabel?.text = "SwiftUI example"
        default:            assertionFailure("unrecognized \(indexPath). Are you trying to add an additional example?")
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
            } else if indexPath.section == 3 {
                switch indexPath.row {
                case 0:
                    let tabBarController = UITabBarController()
                    let contained = SubviewExampleViewController(style: InputBarStyle.slack, conversation: convo)
                    tabBarController.viewControllers = [contained]
                    navigationController?.pushViewController(tabBarController, animated: true)
                case 1:
                    let example = ButtonAnimationExample(style: .imessage, conversation: convo)
                    navigationController?.pushViewController(example, animated: true)
                case 2:
                    let example = UIHostingController(rootView: SwiftUIExample.make(style: .imessage, conversation: convo))
                    navigationController?.pushViewController(example, animated: true)
                default:
                    fatalError("Unknown row \(indexPath.row) in Community Examples section. Are you trying to add a new example?")
                }
            }
        }
    }
}
