//
//  ReceivedMessageTableViewCell.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/31/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class ReceivedMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageHolder: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.size.width / 2
        messageHolder.layer.cornerRadius = 4
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
