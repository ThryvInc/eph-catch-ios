//
//  ProfileViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/9/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: BlankBackViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var extrasLabel: UILabel!
    @IBOutlet weak var nowLabel: UILabel!
    var user: Eph!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.name
        nowLabel.text = user.currentActivity
        majorLabel.text = user.major! as String
        extrasLabel.text = user.extracurriculars! as String
        
        if let imageUrl = user.imageUrl {
            Alamofire.request(.GET, imageUrl as String)
                .responseImage { response in
                    if let image = response.result.value {
                        self.userImageView.image = image
                    }
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageReceived), name: MessagingManager.MessageReceivedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func messageReceived() {
        if self.view.window != nil {
            UIAlertView(title: "New message", message: "Head over to conversations to read it", delegate: nil, cancelButtonTitle: "Sweet!").show()
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! MessagesTableViewController).user = user
    }

}
