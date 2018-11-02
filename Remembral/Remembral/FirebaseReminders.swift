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
    var status = false
}

class FirebaseReminders{
    
    let reminderRef = Database.database().reference(fromURL: "https://remembral-c17af.firebaseio.com/").root.child("reminders")
    
    func getCurrentDayReminder(){
        let day = 1234567
        let query = reminderRef.queryOrdered(byChild: "date").queryEqual(toValue: day)
//        query.obser
        
    }
    
    func getIncompletedReminder(){
        
    }
    
    func setReminder(arg: Reminder!) {
        let childRef = reminderRef.childByAutoId()
        let values : [String:Any] = ["sender": arg!.sender as Any,
                                     "reciever": arg!.reciever as Any,
                                     "description": arg!.description as Any,
                                     "recurrence": arg!.recurrence as Any,
                                     "status": arg!.status,
                                     "date": arg.date as Any,
                                     "hour": arg.hour as Any,
                                     "minute": arg.minute as Any]
        childRef.setValue(values)
    }
}
