//
//  InboxViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2/6/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class InboxViewController: UITableViewController {
    
    lazy var conversations: [SampleData.Conversation] = SampleData.shared.getConversations(count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Inbox"
        tableView.register(InboxCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].title
        cell.detailTextLabel?.text = conversations[indexPath.row].lastMessage?.text
        cell.detailTextLabel?.font = .boldSystemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = .darkGray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ExampleViewController(conversation: conversations[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
