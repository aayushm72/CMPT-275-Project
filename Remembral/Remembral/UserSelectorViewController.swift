//
//  UserSelectorViewViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Aayush Malhotra on 10/29/18.
//  Edited: Aayush Malhotra, Alwin Leong
//
//  Signs in the user as their selected user type
//  Allows for the creation of a new user
//  Known bugs:
//
//


import UIKit
import FirebaseCore
import FirebaseAuth
import SwiftKeychainWrapper

class UserSelectorViewController: UIViewController {
    
    @IBOutlet weak var patientBtn: UIButton!
    @IBOutlet weak var caretakerBtn: UIButton!
    
    var userUID: String!
    enum UserType {
        case UNKNOWN
        case Patient
        case Caretaker
    }
    
    static var currentUserType = UserType.UNKNOWN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUserPtient(_ sender: Any) {
        let email = "patient@remembral.com"
        let password = "PatientPassword"
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(authResult,error) in
            if error == nil {
                self.userUID = authResult?.user.uid
                KeychainWrapper.standard.set(self.userUID, forKey: "uid")
            }else {
                self.createUser(email: email, password: password)
            }
            UserSelectorViewController.currentUserType = UserType.Patient
            FirebaseDatabase.sharedInstance.initializeReminderNotificaions()
            self.performSegue(withIdentifier: "segueToPatient", sender: self)
            
        })
    }
    
    
    @IBAction func onUserCaretaker(_ sender: Any) {
        let email = "caretaker@remembral.com"
        let password = "CaretakerPassword"
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(authResult,error) in
            if error == nil {
                self.userUID = authResult?.user.uid
                KeychainWrapper.standard.set(self.userUID, forKey: "uid")
            }else {
                self.createUser(email: email, password: password)
            }
            UserSelectorViewController.currentUserType = UserType.Caretaker
            FirebaseDatabase.sharedInstance.UpdateFromFirebase(completion: nil)
            self.performSegue(withIdentifier: "segueToCaretaker", sender: self)
        })
    }
    
    func createUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            if error != nil {
                print("There was an error")
                return
            }
        self.userUID = authResult?.user.uid
        KeychainWrapper.standard.set(self.userUID, forKey: "uid")
        //successfully created user user
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
