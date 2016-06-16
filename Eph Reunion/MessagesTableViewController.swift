//
//  MessagesTableViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import SBTextInputView
import Alamofire
import AlamofireImage

class MessagesTableViewController: BlankBackViewController, UITableViewDataSource, UITableViewDelegate, SBTextInputViewDelegate, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textInput: SBTextInputView!
    var textInputAccessory: SBTextInputView!
    var conversation: Conversation?
    var user: Eph?
    var messages: [Message] = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor.init(colorLiteralRed: 0x49/0xff, green: 0x33/0xff, blue: 0x90/0xff, alpha: 1)
        textInputAccessory = SBTextInputView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 50), superView: nil, delegate: self)
        textInputAccessory.button.setTitleColor(color, forState: .Normal)
        textInput.button.setTitleColor(color, forState: .Normal)
        textInput.inputTextView.inputAccessoryView = textInputAccessory
        textInput.inputTextView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refresh), name: MessagingManager.MessageReceivedNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func refresh() {
        if let loadedConversation = conversation {
            user = loadedConversation.user
            GetMessagesCall().getMessages(loadedConversation) { (messages, optError) in
                if let _ = optError {
                    
                }else{
                    self.messages = [Message]()
                    self.messages.appendContentsOf(messages!.reverse())
                    self.tableView?.reloadData()
                    if self.messages.count > 0 {
                        self.tableView.scrollRectToVisible(self.tableView.rectForRowAtIndexPath(NSIndexPath.init(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)), animated: true)
                    }
                }
            }
            title = loadedConversation.user?.name
        }else{
            for convo in MessagingManager.sharedInstance.conversations ?? [Conversation]() {
                if convo.user?.objectId == user?.objectId {
                    conversation = convo
                }
            }
            if conversation != nil {
                refresh()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! ProfileViewController).user = user
    }
    
    func viewUser() {
        performSegueWithIdentifier("profile", sender: self)
    }
    
    // MARK - SBTextInputViewDelegate
    
    func textInputButtonPressed(text: String!) {
        if text != "" {
            if text.characters.count < 100 {
                if let loadedConversation = conversation {
                    let message = Message()
                    message.body = text
                    textInputAccessory.button.enabled = false
                    SendMessageCall().sendMessage(loadedConversation, message: message) { (succeeded, optError) in
                        if succeeded {
                            self.refresh()
                            self.textInput.inputTextView.text = ""
                            self.textInputAccessory.inputTextView.text = ""
                            self.textInputAccessory.notifyTextChange()
                            MessagingManager.sharedInstance.refreshConversations()
                        }
                        self.textInputAccessory.button.enabled = true
                    }
                }else{
                    let message = Message()
                    message.body = text
                    textInputAccessory.button.enabled = false
                    SendMessageCall().sendNew(message, user: user!, completion: { (newConversation, optError) in
                        if let newConvo = newConversation {
                            MessagingManager.sharedInstance.refreshConversations()
                            self.conversation = newConvo
                            self.refresh()
                            
                            self.textInput.inputTextView.text = ""
                            self.textInputAccessory.inputTextView.text = ""
                            self.textInputAccessory.notifyTextChange()
                        }else {
                            UIAlertView(title: "Ruh Roh!", message: "Your message failed to send :/\nTry again?", delegate: nil, cancelButtonTitle: "Ugh, fine").show()
                        }
                        self.textInputAccessory.button.enabled = true
                    })
                }
            }else{
                UIAlertView(title: "Sorry...", message: "Messages are capped at 100 characters long...", delegate: nil, cancelButtonTitle: "Ugh, fine").show()
            }
        }
    }
    
    // MARK - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        textInputAccessory.becomeFirstResponder()
        self.tableViewBottomConstraint.constant = 250
        self.view.updateConstraints()
        if self.messages.count > 0 {
            self.tableView.scrollRectToVisible(self.tableView.rectForRowAtIndexPath(NSIndexPath.init(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)), animated: true)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textInput.inputTextView.text = textInputAccessory.inputTextView.text
        textInput.notifyTextChange()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        let message = messages[indexPath.row]
        if message.userId == Eph.currentUser!.objectId {
            let msgCell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! SentMessageTableViewCell
            msgCell.messageLabel?.text = message.body
            cell = msgCell
        }else{
            let msgCell = tableView.dequeueReusableCellWithIdentifier("otherMessageCell", forIndexPath: indexPath) as! ReceivedMessageTableViewCell
            msgCell.messageLabel?.text = message.body
            if let image = conversation!.user?.image {
                msgCell.userImageView.image = image
            }else if let imageUrl = conversation!.user?.imageUrl {
                msgCell.userImageView.image = nil
                Alamofire.request(.GET, (imageUrl as? String)!)
                    .responseImage { response in
                        if let image = response.result.value {
                            msgCell.userImageView.image = image
                            self.conversation!.user?.image = image
                        }
                }
            }else{
                msgCell.userImageView.image = nil
            }
            cell = msgCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.textInput.resignFirstResponder()
        viewUser()
    }

}
