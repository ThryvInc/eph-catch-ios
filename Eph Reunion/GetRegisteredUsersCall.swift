//
//  GetRegisteredUsersCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetRegisteredUsersCall: AuthenticatedNetworkCall {

    func getUsers(page: Int, completion: ([Eph]?, NSError?) -> Void) {
        endpoint = "users?page-size=20&page=" + String(page)
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let ephHolders: [JsonApiEphHolder] = Eson().fromJsonArray(json["data"] as? [[String : AnyObject]], clazz: JsonApiEphHolder.self)!
                completion(ephHolders.map {$0.attributes!} , nil)
            }
        }
    }
}
