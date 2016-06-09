//
//  MessagingManager.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/31/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class MessagingManager: NSObject {
    static let sharedInstance = MessagingManager()
    var conversations: [Conversation]?
    var isRefreshing: Bool = false
    static let MessagesLoadedNotification = "MessagesLoadedNotification"
    static let MessageReceivedNotification = "MessageReceived"

    func refreshConversations() {
        isRefreshing = true
        GetConversationsCall().getConvos() { (conversations, optError) in
            if let _ = optError {
                
            }else{
                self.conversations = conversations
            }
            self.isRefreshing = false
            NSNotificationCenter.defaultCenter().postNotificationName(MessagingManager.MessagesLoadedNotification, object: nil)
        }
    }
}
