//
//  LikeCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class LikeCall: AuthenticatedNetworkCall {
    
    func likeUser(user: Eph, completion: (Bool, NSError?) -> Void) {
        endpoint = "likes"
        method = "POST"
        
        do {
            let json = ["like": ["likee_id": user.objectId]]
            data = try NSJSONSerialization.dataWithJSONObject(json as AnyObject, options: .PrettyPrinted)
        }catch _ as NSError {
            
        }
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(false, error)
            }else if let json = jsonDict {
                NSUserDefaults.standardUserDefaults().setObject(json["api_key"], forKey: AuthenticatedNetworkCall.UserDefaultsApiKey)
                completion(true, nil)
            }else{
                completion(false, nil)
            }
        }
    }

}
