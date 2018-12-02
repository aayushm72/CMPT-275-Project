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
import SwiftKeychainWrapper
import Firebase

class CaretakerHomeViewController: ReminderViewController {
    
    // Shows all the Reminders that the patient has not been completed in the last 24 hours.
    override func updateReminderTable(){
        FirebaseDatabase.sharedInstance.grabPast24Hours(completion: { (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        print("Logged out!")
        FirebaseDatabase.sharedInstance.rootRef.removeAllObservers()
        try? Auth.auth().signOut()
        KeychainWrapper.standard.removeObject(forKey: "email")
        KeychainWrapper.standard.removeObject(forKey: "password")
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

