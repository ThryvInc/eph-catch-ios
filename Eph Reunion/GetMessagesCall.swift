//
//  GetMessagesCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetMessagesCall: AuthenticatedNetworkCall {
    
    func getMessages(conversation: Conversation, completion: ([Message]?, NSError?) -> Void) {
        endpoint = "conversations/" + String(conversation.objectId) + "/messages?page-size=40"
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let ephHolders: [JsonApiMessageHolder] = Eson().fromJsonArray(json["data"] as? [[String : AnyObject]], clazz: JsonApiMessageHolder.self)!
                completion(ephHolders.map {
                    $0.attributes!.userId = Int($0.relationships!["user"]?["data"]??["id"] as! String)
                    return $0.attributes!
                }, nil)
            }
        }
    }

}
