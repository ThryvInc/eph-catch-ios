//
//  SentMessageTableViewCell.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/31/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class SentMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageHolder: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        messageHolder.layer.cornerRadius = 4
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
