//
//  FirstViewController.swift
//  Remembral
//
//  Created by Aayush Malhotra on 9/21/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
// ******For Home Page


import UIKit
import UserNotifications

struct choices {
    static let answer1 = UNNotificationAction(identifier: "answer1", title: "Snooze" , options: UNNotificationActionOptions.foreground)
    
    static let answer2 = UNNotificationAction(identifier: "answer2", title: "Done" , options: UNNotificationActionOptions.foreground)
}

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var patientName:String = ""
    var patientAddress:String = ""
    var patientPhoneNumber:String = ""
    var caretakerName:String = ""
    var caretakerPhoneNumber:String = ""
    lazy var items = ["My Name:", patientName, "My Address:", patientAddress, "My Phone Number:", patientPhoneNumber, "My Caretaker:", caretakerName, "My Caretaker's Phone Number:", caretakerPhoneNumber]
    let alertMessage = UIAlertController(title: "Message Sent", message: "Your caretaker has recieved your SOS call", preferredStyle: .alert)
    let dismissControl = UIControl()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseDatabase.sharedInstance.UpdateFromFirebase {
            (isFinish) in
            self.patientName = FirebaseDatabase.sharedInstance.userObj.name
            self.patientAddress = FirebaseDatabase.sharedInstance.userObj.address
            self.patientPhoneNumber = FirebaseDatabase.sharedInstance.userObj.phNo
            self.caretakerName = FirebaseDatabase.sharedInstance.userObj.caretakerName
            self.caretakerPhoneNumber = FirebaseDatabase.sharedInstance.userObj.caretakerPhNo
            
            
            self.reloadItems()
            self.collectionView.reloadData()
        }
       /* let category = UNNotificationCategory(identifier: "myCategory", actions: [choices.answer1, choices.answer2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        let content = UNMutableNotificationContent()
        
        
        ///should be puled from one of the list arrays list[indexPath.row]
        content.title = "Title"
        content.categoryIdentifier = "myCategory"
        content.body = "Body"///should be puled from one of the list arrays
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.day = 3
        dateComponents.month  = 11
        dateComponents.hour = 14 /// pulled from
        dateComponents.minute = 25
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)///This should be a calendar notification
        
        let request = UNNotificationRequest(identifier: "testID", content: content, trigger: trigger)
        
        //UNUserNotificationCenter.current().delegate = (self as! UNUserNotificationCenterDelegate)//with this un-commented the choices work
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)*/
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   /* func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if response.actionIdentifier == "answer1"
        {
            print("CORRECT")//where
            
        }
        else
        {
            print("false")
        }
    }*/
    
    func reloadItems(){
        items = ["My Name:", patientName, "My Address:", patientAddress, "My Phone Number:", patientPhoneNumber, "My Caretaker:", caretakerName, "My Caretaker's Phone Number:", caretakerPhoneNumber]
    }
    @IBAction func sendSOS(_ sender: UIButton) {
        self.present(alertMessage, animated: true, completion:{
            self.alertMessage.view.superview?.isUserInteractionEnabled = true
            self.alertMessage.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.myLabel.text = items[indexPath.item]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let EditPersonalInfoViewController = segue.destination as? EditPersonalInfoViewController {
            EditPersonalInfoViewController.intitialPatientName = patientName
            EditPersonalInfoViewController.intitialPatientAddress = patientAddress
            EditPersonalInfoViewController.intitialPatientPhoneNumber = patientPhoneNumber
            EditPersonalInfoViewController.intitialCaretakerName = caretakerName
            EditPersonalInfoViewController.intitialCaretakerPhoneNumber = caretakerPhoneNumber
        }
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func UnwindToHomeScreen(_ segue: UIStoryboardSegue) {
        if let editPage = segue.source as? EditPersonalInfoViewController {
            print(editPage.patientName.text!)
            self.patientName = editPage.patientName.text!
            self.patientAddress = editPage.patientAddress.text!
            self.patientPhoneNumber = editPage.patientPhoneNumber.text!
            self.caretakerName = editPage.caretakerName.text!
            self.caretakerPhoneNumber = editPage.caretakerPhoneNumber.text!
        }
        reloadItems()
        collectionView.reloadData()
    }
}

