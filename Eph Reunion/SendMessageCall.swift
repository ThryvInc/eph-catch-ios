//
//  SendMessageCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class SendMessageCall: AuthenticatedNetworkCall {
    
    func sendNew(message: Message, user: Eph, completion: (Conversation?, NSError?) -> Void) {
        endpoint = "conversations"
        method = "POST"
        
        do {
            let json = ["conversation": ["messages": [["body": message.body!]] as [[String: String]], "participants": [["user_id": user.objectId]]]]
            data = try NSJSONSerialization.dataWithJSONObject(json as AnyObject, options: .PrettyPrinted)
        }catch _ as NSError {
            
        }
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                completion(JsonApiConversationParser.parse(json)!.first, nil)
            }else{
                completion(nil, nil)
            }
        }
    }
    
    func sendMessage(conversation: Conversation, message: Message, completion: (Bool, NSError?) -> Void) {
        endpoint = "conversations/" + String(conversation.objectId) + "/messages"
        method = "POST"
        
        do {
            let json = ["message": ["body": message.body!]]
            data = try NSJSONSerialization.dataWithJSONObject(json as AnyObject, options: .PrettyPrinted)
        }catch _ as NSError {
            
        }
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(false, error)
            }else if let _ = jsonDict {
                completion(true, nil)
            }else{
                completion(false, nil)
            }
        }
    }

}
