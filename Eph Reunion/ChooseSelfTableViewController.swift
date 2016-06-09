//
//  ChooseSelfTableViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/25/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class ChooseSelfTableViewController: BlankBackTableViewController {
    var sessions: [Session]!
    var chosenSession: Session!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Who are you?"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath)
        cell.textLabel?.text = sessions[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let progressView = UIActivityIndicatorView()
        progressView.activityIndicatorViewStyle = .Gray
        let progressBarItem = UIBarButtonItem(customView: progressView)
        navigationItem.rightBarButtonItem = progressBarItem
        progressView.startAnimating()
        
        chosenSession = sessions[indexPath.row]
        SelectUnregisteredUserCall().selectUser(chosenSession) {(success, optError) in
            if success {
                self.performSegueWithIdentifier("verify", sender: self)
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! VerifyUserViewController).session = chosenSession
    }

}
