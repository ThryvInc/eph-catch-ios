//
//  SelectUnregisteredUserCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/22/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class SelectUnregisteredUserCall: BaseNetworkCall {
    
    func selectUser(session: Session, completion: (Bool, NSError?) -> Void) {
        endpoint = "sessions/" + String(session.objectId)
        
        executeWithCompletionBlock { (jsonDict, optError) in
            if let error = optError {
                if error.code == 3840 {
                    completion(true, nil)
                }else{
                    completion(false, error)
                }
            }else {
                completion(true, nil)
            }
        }
    }

}
