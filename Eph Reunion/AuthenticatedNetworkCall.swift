//
//  AuthenticatedNetworkCall.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/21/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class AuthenticatedNetworkCall: BaseNetworkCall {
    static let UserDefaultsApiKey = "eph_production_api_key"
    
    override var mutableRequest: NSMutableURLRequest? {
        get {
            let _mutableRequest = super.mutableRequest
            if let apiKey = getApiKey() {
                _mutableRequest?.addValue(apiKey, forHTTPHeaderField: "X-EphcatchReunion-Api-Key")
            }
            return _mutableRequest
        }
    }
    
    func getApiKey() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(AuthenticatedNetworkCall.UserDefaultsApiKey)
    }
}
