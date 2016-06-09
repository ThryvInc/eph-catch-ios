//
//  UpdateUserCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class UpdateUserCall: AuthenticatedNetworkCall {
    
    func updateUser(eph: Eph, completion: (Bool, NSError?) -> Void) {
        endpoint = "users"
        method = "PATCH"
        
        do {
            let eson = Eson()
            eson.serializers.append(NSStringSerializer())
            eson.serializers.append(NSMutableStringSerializer())
            
            let json = ["user": eson.toJsonDictionary(eph)!]
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
