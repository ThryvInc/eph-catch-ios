//
//  GetConversationsCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetConversationsCall: AuthenticatedNetworkCall {
    
    func getConvos(completion: ([Conversation]?, NSError?) -> Void) {
        endpoint = "conversations?page-size=200"
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let conversations = JsonApiConversationParser.parse(json)
                completion(conversations, nil)
            }
        }
    }

}
