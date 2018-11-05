//
//  FirstViewController.swift
//  Remembral
//
//  Created by Aayush Malhotra on 9/21/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
// ******For Home Page
// For the Patient.
// Shows a collection of cells displaying the user's information.
// Allows the user to change their information, which will be updated in the database.
// Allows the user to send SOS messages to their caretaker.


import UIKit
import UserNotifications
import MessageUI

struct choices {
    static let answer1 = UNNotificationAction(identifier: "answer1", title: "Snooze" , options: UNNotificationActionOptions.foreground)
    
    static let answer2 = UNNotificationAction(identifier: "answer2", title: "Done" , options: UNNotificationActionOptions.foreground)
}

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMessageComposeViewControllerDelegate {
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
     
    }

    func reloadItems(){
        items = ["My Name:", patientName, "My Address:", patientAddress, "My Phone Number:", patientPhoneNumber, "My Caretaker:", caretakerName, "My Caretaker's Phone Number:", caretakerPhoneNumber]
    }
    @IBAction func sendSOS(_ sender: UIButton) {
        
        print(MFMessageComposeViewController.canSendText())
        if (MFMessageComposeViewController.canSendText()){
            
        
            let msgVC = MFMessageComposeViewController()
        
            msgVC.body = "SOS"
            msgVC.recipients = [FirebaseDatabase.sharedInstance.userObj.caretakerPhNo]
            msgVC.messageComposeDelegate = self
        
            self.present(msgVC, animated: true, completion: nil)
        
        self.present(alertMessage, animated: true, completion:{
            self.alertMessage.view.superview?.isUserInteractionEnabled = true
            self.alertMessage.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
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

