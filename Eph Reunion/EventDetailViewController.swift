//
//  EventDetailViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/27/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    var event: Event!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = event.name
        timeLabel.text = event.time
        placeLabel.text = event.location
        descriptionLabel.text = event.eventDescription
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

}
