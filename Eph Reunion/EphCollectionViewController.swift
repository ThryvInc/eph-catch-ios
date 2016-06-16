//
//  EphCollectionViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/5/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SSPullToRefresh

private let userReuseIdentifier = "userCell"
private let offsetReuseIdentifier = "offsetCell"

class EphCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SSPullToRefreshViewDelegate {
    var pullToRefreshView: SSPullToRefreshView?
    let width = UIScreen.mainScreen().bounds.width / 2 - 4
    var users: [Eph]! = [Eph]()
    var selectedUser: Eph?
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setBlankBackButton()
        
        tabBarController?.setBlankBackButton()
        
        let flowLayout: EphCollectionViewLayout = EphCollectionViewLayout()
        self.collectionView?.collectionViewLayout = flowLayout
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.tabBarController?.tabBar.translucent = false
        self.tabBarController?.tabBar.barTintColor = UIColor.init(colorLiteralRed: 0x49/0xff, green: 0x33/0xff, blue: 0x90/0xff, alpha: 1)
        self.tabBarController?.tabBar.tintColor = UIColor.init(colorLiteralRed: 0xfe/0xff, green: 0xc2/0xff, blue: 0x3b/0xff, alpha: 1)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(messageReceived), name: MessagingManager.MessageReceivedNotification, object: nil)
        
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Ephs"
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if pullToRefreshView == nil {
            pullToRefreshView = SSPullToRefreshView(scrollView: collectionView, delegate: self)
        }
    }
    
    func messageReceived() {
        let badgeValue = tabBarController?.tabBar.items![2].badgeValue
        tabBarController?.tabBar.items![2].badgeValue = String(Int(badgeValue ?? "0")! + 1)
        MessagingManager.sharedInstance.refreshConversations()
        if self.view.window != nil {
            UIAlertView(title: "New message", message: "Head over to conversations to read it", delegate: nil, cancelButtonTitle: "Sweet!").show()
        }
    }

    func refresh() {
        page = 1
        GetRegisteredUsersCall().getUsers(page) { (ephs, optError) in
            if let _ = optError {
                
            }else{
                self.users = ephs
                self.collectionView?.reloadData()
                self.pullToRefreshView?.finishLoading()
            }
        }
    }
    
    func nextPage() {
        page += 1
        GetRegisteredUsersCall().getUsers(page) { (ephs, optError) in
            if let _ = optError {
                
            }else{
                self.users.appendContentsOf(ephs!)
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: - SSPullToRefreshViewDelegate
    
    func pullToRefreshViewDidStartLoading(view: SSPullToRefreshView!) {
        refresh()
    }
    
    // MARK: - Navigation
     
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile" {
            if let user = selectedUser {
                (segue.destinationViewController as! ProfileViewController).user = user
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = users.count + 1
        return count > 1 ? count : 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if indexPath.item == 0 {
            let offsetCell: OffsetCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(offsetReuseIdentifier, forIndexPath: indexPath) as! OffsetCollectionViewCell
            offsetCell.infoLabel.text = "Tap on a user to see more!"
            offsetCell.infoLabel.preferredMaxLayoutWidth = width - 16
            
            cell = offsetCell
        }else if indexPath.item - 1 < users.count {
            let userCell: UserCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(userReuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
            userCell.backgroundWidthConstraint.constant = width
            let user = users[indexPath.item - 1]
            userCell.usernameLabel.text = user.name
            userCell.userSubtitleLabel.text = user.currentActivity
            if let image = user.image {
                userCell.userImageView.image = image
            }else if let imageUrl = user.imageUrl {
                userCell.userImageView.image = nil
                Alamofire.request(.GET, imageUrl)
                    .responseImage { response in
                        if let image = response.result.value {
                            userCell.userImageView.image = image
                            user.image = image
                        }
                }
            }
            cell = userCell
        }else {
            let userCell: UserCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(userReuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
            userCell.backgroundWidthConstraint.constant = width
            let user = Eph.generateDummyUser()
            userCell.usernameLabel.text = user.name
            userCell.userSubtitleLabel.text = user.currentActivity
            if let imageUrl = user.imageUrl {
                Alamofire.request(.GET, imageUrl)
                    .responseImage { response in
                        if let image = response.result.value {
                            userCell.userImageView.image = image
                        }
                }
            }
            cell = userCell
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == users.count - 3 && users.count % 20 == 0 {
            nextPage()
        }
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item != 0 {
            selectedUser = users[indexPath.item - 1]
            self.performSegueWithIdentifier("profile", sender: self)
        }
    }

}
