//
//  ConversationsTableViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ConversationsTableViewController: BlankBackTableViewController {
    var selectedConversation: Conversation!
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = "Conversations"
        refresh()
        tabBarController?.tabBar.items![2].badgeValue = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refresh), name: MessagingManager.MessageReceivedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reload), name: MessagingManager.MessagesLoadedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refresh() {
        if !MessagingManager.sharedInstance.isRefreshing {
            MessagingManager.sharedInstance.refreshConversations()
        }else {
            reload()
        }
    }
    
    func reload() {
        if self.isViewLoaded() && self.view.window != nil {
            tabBarController?.tabBar.items![2].badgeValue = nil
        }
        self.tableView?.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagingManager.sharedInstance.conversations?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("convoCell", forIndexPath: indexPath) as! ConversationTableViewCell
        let conversation = MessagingManager.sharedInstance.conversations![indexPath.row]
        cell.userLabel?.text = conversation.user?.name
        cell.lastMessageLabel?.text = conversation.lastMessage
        cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.size.width / 2
        if let image = conversation.user?.image {
            cell.userImageView.image = image
        }else if let imageUrl = conversation.user?.imageUrl {
            cell.userImageView.image = nil
            Alamofire.request(.GET, imageUrl as String)
                .responseImage { response in
                    if let image = response.result.value {
                        cell.userImageView.image = image
                        conversation.user?.image = image
                    }
            }
        }else{
            cell.userImageView.image = nil
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedConversation = MessagingManager.sharedInstance.conversations![indexPath.row]
        
        performSegueWithIdentifier("messages", sender: self)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! MessagesTableViewController).conversation = selectedConversation
    }
}
