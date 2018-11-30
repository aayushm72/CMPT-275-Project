//
//  CaretakerHomeViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Alwin Leong on 11/2/18.
//  Edited: Alwin Leong
//
// For Caretaker Homepage
//  Known bugs:
//
//

import UIKit

class CaretakerHomeViewController: ReminderViewController {
    
    // Shows all the Reminders that the patient has not been completed in the last 24 hours.
    override func updateReminderTable(){
        FirebaseDatabase.sharedInstance.grabPast24Hours(completion: { (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        })
    }
}

