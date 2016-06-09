//
//  Event.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/23/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class Event: NSObject, EsonKeyMapper {
    var name: String?
    var location: String?
    var day: String?
    var time: String?
    var eventDescription: String?
    
    static func esonPropertyNameToKeyMap() -> [String : String] {
        return ["eventDescription": "description"]
    }
}
