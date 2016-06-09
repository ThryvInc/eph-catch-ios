//
//  GetEventsCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetEventsCall: AuthenticatedNetworkCall {

    func getEvents(completion: ([Event]?, NSError?) -> Void) {
        endpoint = "events?page-size=100"
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let ephHolders: [JsonApiEventHolder] = Eson().fromJsonArray(json["data"] as? [[String : AnyObject]], clazz: JsonApiEventHolder.self)!
                completion(ephHolders.map {$0.attributes!} , nil)
            }
        }
    }
}
