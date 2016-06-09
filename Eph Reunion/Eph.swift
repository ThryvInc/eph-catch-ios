//
//  Eph.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/5/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Eson

class Eph: NSObject, EsonKeyMapper {
    static let IdKey = "IdKey"
    static let NameKey = "NameKey"
    static let MajorKey = "MajorKey"
    static let ExtracurricularsKey = "ExtracurricularsKey"
    static let CurrentKey = "CurrentKey"
    static let ImageUrlKey = "ImageUrlKey"
    static var deviceToken: String?
    static var currentUser: Eph? {
        get {
            if let _ = _currentUser {
                return _currentUser
            }
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let eph = Eph()
            eph.objectId = defaults.integerForKey(IdKey)
            eph.name = defaults.stringForKey(NameKey)
            eph.major = defaults.stringForKey(MajorKey)
            eph.extracurriculars = defaults.stringForKey(ExtracurricularsKey)
            eph.currentActivity = defaults.stringForKey(CurrentKey)
            eph.imageUrl = defaults.stringForKey(ImageUrlKey)
            return eph
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger((user?.objectId)!, forKey: IdKey)
            defaults.setValue(user?.name, forKey: NameKey)
            defaults.setValue(user?.major, forKey: MajorKey)
            defaults.setValue(user?.extracurriculars, forKey: ExtracurricularsKey)
            defaults.setValue(user?.currentActivity, forKey: CurrentKey)
            defaults.setValue(user?.imageUrl, forKey: ImageUrlKey)
            defaults.synchronize()
        }
    }
    
    private static var _currentUser: Eph?
    var objectId = 0
    var name: String?
    var major: String?
    var extracurriculars: String?
    var currentActivity: String?
    var imageUrl: String?
    let deviceType = "ios"
    var pushToken: String?
    var image: UIImage?
    
    static func generateDummyUser() -> Eph {
        let user = Eph()
        user.name = "Ephraim Williams";
        user.major = "Defeating-the-French major";
        user.extracurriculars = "Being a Colonel, Establishing schools";
        user.currentActivity = "Namesake of the best college evar";
        user.imageUrl = "https://s-media-cache-ak0.pinimg.com/736x/9e/a7/90/9ea790fc99d386ff0126e1ee1ac8265a.jpg";
        return user
    }
    
    static func esonPropertyNameToKeyMap() -> [String : String] {
        return ["objectId":"id","imageUrl":"image-url", "currentActivity":"current-activity"]
    }
    
}
