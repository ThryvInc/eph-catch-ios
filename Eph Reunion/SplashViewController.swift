//
//  SplashViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    var apiKey: String?
    var sessions: [Session]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if OnboardingManager.isOnboardingCompleted() {
            performSegueWithIdentifier("splashTabs", sender: self)
        }else{
            if let _ = NSUserDefaults.standardUserDefaults().stringForKey(AuthenticatedNetworkCall.UserDefaultsApiKey) {
                performSegueWithIdentifier("splashEdit", sender: self)
            }else{
                GetUnregisteredUsersCall().getUsers { (optSessions, optError) in
                    if let _ = optError {
                        
                    }else if let returnedSessions = optSessions {
                        self.sessions = returnedSessions.sort {$0.name!.localizedCaseInsensitiveCompare($1.name!) == NSComparisonResult.OrderedAscending}
                        self.performSegueWithIdentifier("splashReg", sender: self)
                    }else{
                        //error
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userChoices = sessions{
            ((segue.destinationViewController as! UINavigationController).topViewController as! ChooseSelfTableViewController).sessions = userChoices
        }
        if segue.identifier == "splashEdit" {
            (segue.destinationViewController as! EditProfileViewController).session = Session()
        }
    }

}
