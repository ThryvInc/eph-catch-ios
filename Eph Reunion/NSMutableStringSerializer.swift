//
//  NSMutableStringSerializer.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/31/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

public class NSMutableStringSerializer: Serializer {
    public func objectForValue(value: AnyObject?) -> AnyObject? {
        return value
    }
    public func exampleValue() -> AnyObject {
        return NSMutableString()
    }
}
