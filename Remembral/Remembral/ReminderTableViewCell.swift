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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var snoozeButton: UIButton!
    
    @IBAction func onPressDone(_ sender: UIButton) {
        
    }
    
    @IBAction func onSnooze(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Add code to check if current time is close to sceduled time, allowing the user to press "Done early"
        //Snooze is only enabled when Reminder has been triggered.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
