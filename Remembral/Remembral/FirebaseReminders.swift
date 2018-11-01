//
//  Reminder.swift
//  Remembral
//
//  Created by Aayush Malhotra on 11/1/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit
import Firebase

struct Reminder {
    var sender:String?
    var reciever:String?
    var description:String?
    var date: Int?
    var hour: Int?
    var minute: Int?
    var recurrence: String?
    var status = Bool?
}

class FirebaseReminders{
    let reminderRef = Database.database().reference().child("reminders")
    
    func getCurrentDayReminder(){
        let date = Date()
        let calender = Calendar.current
        let day = calender.component(.day, from: date)
        
    }
    
    func getIncompletedReminder(){
        
    }
    
    func setReminder(arg: Reminder) {
        let childRef = reminderRef.childByAutoId()
        let values = ["sender": arg.sender, "reciever": arg.reciever, "description": arg.description, "recurrence": arg.recurrence, "status": arg.status]
        childRef.updateChildValues(values)
    }
}
