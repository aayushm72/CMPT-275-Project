//
//  ReminderTableViewCell.swift
//  Remembral
//
//Team: Group 2
//  Created by Alwin Leong on 10/31/18.
//  Edited: Alwing Leong
//
//  Known bugs:
//
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var ReminderLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var snoozeButton: UIButton!
    var reminderDBKey: String!
    var delegate: ReminderViewController!
    
    @IBAction func onPressDone(_ sender: UIButton) {
        let ownRef = FirebaseDatabase.sharedInstance.reminderRef.child(reminderDBKey as String)
        ownRef.updateChildValues(["status": true])
        FirebaseDatabase.sharedInstance.updateRemindersThen{
            (isFinish) in self.delegate.tableView.reloadData()
        }
        doneButton.isHidden = true
        snoozeButton.isHidden = true
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
