//
//  EditProfileViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Alamofire
import Parse
import Bolts

class EditProfileViewController: BlankBackViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var extraTextField: UITextField!
    @IBOutlet weak var currentTextField: UITextField!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var session: Session?
    var user: Eph?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.title = "Edit Profile"

        if let thisSession = session {
            if thisSession.objectId == 0 {
                user = Eph.currentUser!
            }else{
                user = Eph()
                user!.objectId = thisSession.objectId
                user!.name = thisSession.name
                Eph.currentUser = user
            }
        }else{
            user = Eph.currentUser!
        }
        
        setupUser()
        registerForPushNotifications(UIApplication.sharedApplication())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageReceived), name: MessagingManager.MessageReceivedNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func messageReceived() {
        if self.view.window != nil {
            UIAlertView(title: "New message", message: "Head over to conversations to read it", delegate: nil, cancelButtonTitle: "Sweet!").show()
        }
    }
    
    func setupUser() {
        if let thisUser = user {
            nameTextField.text = thisUser.name
            majorTextField.text = thisUser.major
            extraTextField.text = thisUser.extracurriculars
            currentTextField.text = thisUser.currentActivity
            
            if let imageUrl = thisUser.imageUrl {
                Alamofire.request(.GET, (imageUrl as? String)!)
                    .responseImage { response in
                        if let image = response.result.value {
                            self.pictureButton.setBackgroundImage(image, forState: .Normal)
                        }
                }
            }
        }
    }
    
    func setupUserImage() {
        if let thisUser = user {
            if let imageUrl = thisUser.imageUrl {
                Alamofire.request(.GET, (imageUrl as? String)!)
                    .responseImage { response in
                        if let image = response.result.value {
                            self.pictureButton.setBackgroundImage(image, forState: .Normal)
                        }
                }
            }
        }
    }

    @IBAction func picturePressed() {
        chooseImageSource()
    }
    
    @IBAction func savePressed() {
        if nameTextField.text == "" {
            UIAlertView(title: "Blank Name", message: "As you might expect, we do need your name", delegate: nil, cancelButtonTitle: "Whoops, my bad").show()
        }else if majorTextField.text == "" {
            UIAlertView(title: "Major", message: "Your major is blank! Surely you majored in something...", delegate: nil, cancelButtonTitle: "Um, of course I did").show()
        }else if extraTextField.text == "" {
            UIAlertView(title: "Extracurriculars", message: "Extracurriculars is blank... I'm sure you did SOMEthing other than study", delegate: nil, cancelButtonTitle: "Ohhh. Right.").show()
        }else if currentTextField.text == "" {
            UIAlertView(title: "Current Activity", message: "Current activity is blank! You've gotta be doing SOMEthing...", delegate: nil, cancelButtonTitle: "Oops").show()
        }else if user?.imageUrl == nil || user?.imageUrl == "" {
            UIAlertView(title: "Image", message: "Please choose an image!", delegate: nil, cancelButtonTitle: "Sorry, I forgot").show()
        }else if let thisUser = user {
            thisUser.name = nameTextField.text
            thisUser.major = majorTextField.text
            thisUser.extracurriculars = extraTextField.text
            thisUser.currentActivity = currentTextField.text
            if let deviceToken = Eph.deviceToken {
                thisUser.pushToken = deviceToken
            }
            
            UpdateUserCall().updateUser(thisUser, completion: { (succeeded, optError) in
                if succeeded {
                    if let _ = self.session {
                        OnboardingManager.setOnboardingCompleted()
                        self.performSegueWithIdentifier("doneOnboarding", sender: self)
                    }else{
                        UIAlertView(title: "Success!", message: "Your profile was saved.", delegate: nil, cancelButtonTitle: "Yay!").show()
                    }
                    self.hideKeyboard()
                    Eph.currentUser = thisUser
                }else{
                    UIAlertView(title: "Oh noes!", message: "Something went wrong while saving your profile :( \nTry again?", delegate: nil, cancelButtonTitle: "If you say so...").show()
                }
            })
        }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func chooseImageSource() {
        let alertController: UIAlertController = UIAlertController(title: "From where?", message: "", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            self.showSource(.Camera)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .Default) { (action) in
            self.showSource(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSource(type: UIImagePickerControllerSourceType) {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = session {
            
        }
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        loadingIndicator.hidden = false
        
        let imageFile: PFFile = PFFile(data: UIImageJPEGRepresentation(image, 0.5)!)!
        imageFile.saveInBackgroundWithBlock { (succeeded, optError) in
            if succeeded {
                self.loadingIndicator.hidden = true
                
                self.user?.imageUrl = imageFile.url
                self.setupUserImage()
            }
        }
    }
}
