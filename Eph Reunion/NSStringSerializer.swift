//
//  NSCFStringSerializer.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/26/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

public class NSStringSerializer: Serializer {
    public func objectForValue(value: AnyObject?) -> AnyObject? {
        return value
    }
    public func exampleValue() -> AnyObject {
        return NSString()
    }
}
