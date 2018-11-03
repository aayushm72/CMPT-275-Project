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
    var sender:String!
    var reciever:String!
    var description:String!
    var date: Int!
    var month: Int!
    var hour: Int!
    var minute: Int!
    var recurrence: String!
    var status = false
    var databaseKey: String!
    func getDay() -> Int!{
        return date
    }
    func getHour() -> Int!{
        return hour
    }
    func getMinute() -> Int!{
        return minute
    }
    
}

struct User {
    var name:String!
    var address: String!
    var phNo: String!
    var caretakerName: String!
    var caretakerPhNo: String!
}

class FirebaseDatabase: NSObject{
    
    
    let reminderRef = Database.database().reference(fromURL: "https://remembral-c17af.firebaseio.com/").root.child("reminders")
    let usersRef = Database.database().reference(fromURL: "https://remembral-c17af.firebaseio.com/").root.child("users")
    
    var userObj: User!
    var reminderList = [Reminder]()
    
    override init()
    {
        super.init()
        /*self.UpdateFromFirebase{
            (isFinish) in print(isFinish)
        }*/
        updateReminders()
        
    }
    class var sharedInstance: FirebaseDatabase {
        struct Static {
            static var instance: FirebaseDatabase = FirebaseDatabase()
        }
        return Static.instance
    }
    func updateReminders(){
        _updateReminder {
            (dict) in
            FirebaseDatabase.sharedInstance.reminderList += dict
        }
    }
    func _updateReminder(completion:(([Reminder]) -> Void)?){
        reminderList.removeAll()
        reminderRef.queryOrdered(byChild: "date").observe(.value, with: { (snapshot: DataSnapshot) in
            var asdf = [Reminder]()
            for snap in snapshot.children {
                if let rData = (snap as! DataSnapshot).value as? [String:Any]{
                    
                    let newR = Reminder(sender: rData["sender"] as! String,
                                        reciever: rData["reciever"] as! String,
                                        description: rData["description"] as! String,
                                        date: rData["date"] as! Int,
                                        month: (rData["month"] ?? 1) as! Int,
                                        hour: rData["hour"] as! Int,
                                        minute: rData["minute"] as! Int,
                                        recurrence: rData["recurrence"] as! String,
                                        status: rData["status"] as! Bool,
                                        databaseKey: (snap as! DataSnapshot).key)
                   asdf += [newR]
                }
            }
            completion? (asdf)
            //let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            // ...
        })
    }
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
                                     "month": arg.month as Any,
                                     "hour": arg.hour as Any,
                                     "minute": arg.minute as Any]
        childRef.setValue(values)
    }
    
    func setUserData(arg: User!){
        self.userObj = arg
        let userID = Auth.auth().currentUser?.uid
        let childRef = usersRef.child(userID!)
        let values : [String:Any] = ["name": arg.name,
                      "address": arg.address,
                      "phNo": arg.phNo,
                      "caretakerName": arg.caretakerName,
                      "caretakerPhNo": arg.caretakerPhNo]
        childRef.updateChildValues(values)
    }

    func UpdateFromFirebase(completion: ((Bool) -> Void)?){
        let userID = Auth.auth().currentUser?.uid
        let childRef = usersRef.child(userID!)
        childRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String:String]
            self.userObj = User(name: userDict["name"],
                                address: userDict["address"],
                                phNo: userDict["phNo"],
                                caretakerName: userDict["caretakerName"],
                                caretakerPhNo: userDict["caretakerPhNo"]
            )
            
            completion? (true)
        })
    }
    
    func getUserData() -> User {
        return self.userObj
    }
    
    
}
