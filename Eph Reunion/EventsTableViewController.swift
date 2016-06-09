//
//  EventsTableViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/24/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class EventsTableViewController: BlankBackTableViewController {
    var days: [[Event]]?
    var chosenEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = "Events"
    }
    
    func refresh() {
        GetEventsCall().getEvents { (optEvents, optError) in
            self.days = [[Event]]()
            if let events = optEvents {
                for event in events {
                    if self.days?.count == 0 {
                        self.days?.append([event])
                    }else{
                        var daysEvents: [Event]! = self.days?.last
                        if daysEvents.last?.day == event.day {
                            daysEvents.append(event)
                            self.days?[(self.days?.count)! - 1] = daysEvents
                        }else{
                            self.days?.append([event])
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return days?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = days?[section].count
        return count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return days?[section].first?.day
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        let daysEvents = days![indexPath.section]
        let event = daysEvents[indexPath.row]
        cell.titleLabel?.text = event.name
        cell.timeLabel?.text = event.time
        cell.placeLabel?.text = event.location
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        chosenEvent = days![indexPath.section][indexPath.row]
        performSegueWithIdentifier("eventDetail", sender: self)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! EventDetailViewController).event = chosenEvent!
    }

}
