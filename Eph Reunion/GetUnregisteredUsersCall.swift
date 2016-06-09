//
//  GetUnregisteredUsersCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetUnregisteredUsersCall: BaseNetworkCall {
    
    func getUsers(completion: ([Session]?, NSError?) -> Void) {
        endpoint = "sessions"
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let sessionHolders: [JsonApiSessionHolder] = Eson().fromJsonArray(json["data"] as? [[String : AnyObject]], clazz: JsonApiSessionHolder.self)!
                completion(sessionHolders.map {$0.attributes!} , nil)
            }
        }
    }

}
