//
//  CaretakerReminderViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Alwin Leong on 11/2/18.
//  Edited: Alwin Leong
//
// For Caretaker Reminder list page
//  Known bugs:
//
//

import UIKit

// Shows all the reminders assigned to patient. These reminders can be set by patient and by caretaker.
class CaretakerReminderViewController: ReminderViewController {
    
    @IBOutlet weak var AddReminderButton: UIButton!
    
    override func updateReminderTable(){
        FirebaseDatabase.sharedInstance.updateRemindersThen(completion: { (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !FirebaseDatabase.sharedInstance.isSelectedPatientValid() {
            AddReminderButton.isEnabled = false
        }
        super.viewWillAppear(true)
    }
}
