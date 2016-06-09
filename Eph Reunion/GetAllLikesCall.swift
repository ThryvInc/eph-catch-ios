//
//  GetAllLikesCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class GetAllLikesCall: AuthenticatedNetworkCall {
    
    func getLikes(completion: ([Like]?, NSError?) -> Void) {
        endpoint = "likes"
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(nil, error)
            }else if let json = jsonDict {
                let ephHolders: [JsonApiLikeHolder] = Eson().fromJsonArray(json["data"] as? [[String : AnyObject]], clazz: JsonApiLikeHolder.self)!
                completion(ephHolders.map {$0.attributes!} , nil)
            }
        }
    }

}
