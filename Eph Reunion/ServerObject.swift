//
//  ServerObject.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

public class ServerObject: NSObject, EsonKeyMapper {
    var objectId: Int = 0
    
    public static func esonPropertyNameToKeyMap() -> [String : String] {
        return ["objectId":"id"]
    }
}
