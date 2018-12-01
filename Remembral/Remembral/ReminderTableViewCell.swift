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
import FirebaseAuth

class ReminderTableViewCell: UITableViewCell {

    // Reminder label
    @IBOutlet weak var ReminderLabel: UILabel!
    // Done Button
    @IBOutlet weak var doneButton: UIButton!
    var reminderDBKey: String!
    var delegate: ReminderViewController!
    
    // For done action, completes a reminder.
    @IBAction func onPressDone(_ sender: UIButton) {
        let uid = (FirebaseDatabase.sharedInstance.userObj.type == User.CARETAKER ?  FirebaseDatabase.sharedInstance.getSelectedPatientID() : Auth.auth().currentUser?.uid)
        let ownRef = FirebaseDatabase.sharedInstance.reminderRef.child(uid!).child(reminderDBKey as String)
        ownRef.updateChildValues(["status": true])
        FirebaseDatabase.sharedInstance.updateRemindersThen{
            (isFinish) in self.delegate.tableView.reloadData()
        }
        doneButton.isHidden = true
    }
    
    // Awake the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Add code to check if current time is close to sceduled time, allowing the user to press "Done early"
        //Snooze is only enabled when Reminder has been triggered.
      
        
    }

    // Selected Cell
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
