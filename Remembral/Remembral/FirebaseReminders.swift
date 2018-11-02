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
    
    var userObj = User()
    var reminderList = [Reminder]()
    
    override init()
    {
        super.init()
        //self.UpdateFromFirebase(completionHandler: nil)
        updateReminder {
            (dict) in
            FirebaseDatabase.sharedInstance.reminderList += dict
        }
        
    }
    class var sharedInstance: FirebaseDatabase {
        struct Static {
            static var instance: FirebaseDatabase = FirebaseDatabase()
        }
        return Static.instance
    }
    func updateReminder(completion:(([Reminder]) -> Void)?){
        reminderRef.queryOrdered(byChild: "date").observe(.value, with: { (snapshot: DataSnapshot) in
            var asdf = [Reminder]()
            for snap in snapshot.children {
                print((snap as! DataSnapshot).key, (snap as! DataSnapshot).value)
                if let rData = (snap as! DataSnapshot).value as? [String:Any]{
                    let newR = Reminder(sender: rData["sender"] as! String,
                                        reciever: rData["reciever"] as! String,
                                        description: rData["description"] as! String,
                                        date: rData["date"] as! Int,
                                        month: 1, //rData["month"] as! Int,
                                        hour: rData["hour"] as! Int,
                                        minute: rData["minute"] as! Int,
                                        recurrence: rData["recurrence"] as! String,
                                        status: rData["status"] as! Bool )
                   asdf += [newR]
                    print("Add new element")
                } else {
                    print("Not add")
                    
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
    typealias UpdateComplete = (Bool?) -> Void
    func UpdateFromFirebase(completionHandler:@escaping UpdateComplete){
        let userID = Auth.auth().currentUser?.uid
        let childRef = usersRef.child(userID!)
        childRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String:String]
            
            self.userObj.name = userDict["name"] 
            self.userObj.address = userDict["address"]
            self.userObj.name = userDict["phNo"]
            self.userObj.address = userDict["caretakerName"]
            self.userObj.name = userDict["caretakerPhNO"]
            
            DispatchQueue.main.async() {
                if userDict.isEmpty{
                    completionHandler(true)
                }else {
                    completionHandler(nil)
                }
            }
        })
    }
    
    func getUserData() -> User {
        return self.userObj
    }
    
    
}
