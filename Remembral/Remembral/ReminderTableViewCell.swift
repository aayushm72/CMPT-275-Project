//
//  ReminderTableViewCell.swift
//  Remembral
//
//  Created by Alwin Leong on 10/31/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var ReminderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
