//
//  RegisterUserCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class RegisterUserCall: BaseNetworkCall {
    
    func registerUser(session: Session, completion: (Bool, NSError?) -> Void) {
        endpoint = "sessions"
        method = "POST"
        
        do {
            let json = ["session": ["email":session.email!, "password":session.password!]]
            data = try NSJSONSerialization.dataWithJSONObject(json as AnyObject, options: .PrettyPrinted)
        }catch _ as NSError {
            
        }
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                completion(false, error)
            }else if let json = jsonDict {
                NSUserDefaults.standardUserDefaults().setObject(json["data"]?["attributes"]??["api-key"], forKey: AuthenticatedNetworkCall.UserDefaultsApiKey)
                completion(true, nil)
            }else{
                completion(false, nil)
            }
        }
    }

}
