//
//  VerifyUserViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class VerifyUserViewController: BlankBackViewController {
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var instructionLabel: UILabel!
    var session: Session!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionLabel.text = "You should soon receive an email with your pin to:\n\n\(session.email!)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func verifyPressed() {
        let sessionVerification = Session()
        sessionVerification.objectId = session.objectId
        sessionVerification.email = session.email
        sessionVerification.password = pinTextField.text
        RegisterUserCall().registerUser(sessionVerification) { (succeeded, optError) in
            if succeeded {
                self.performSegueWithIdentifier("editProfile", sender: self)
            }
        }
    }
    
    @IBAction func troublePressed() {
        let subject = "Reunion Email Issue"
        let address = "ephcatchreunion@gmail.com"
        let url = NSURL(string: "mailto:?to=\(address)&subject=\(subject)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! EditProfileViewController).session = session
    }

}
