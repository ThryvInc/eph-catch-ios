//
//  OnboardingManager.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/26/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import Foundation

class OnboardingManager {
    static let DefaultsKey = "CompletedOnboardingKey"
    
    static func isOnboardingCompleted() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(DefaultsKey)
    }
    
    static func setOnboardingCompleted() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultsKey)
    }
}
