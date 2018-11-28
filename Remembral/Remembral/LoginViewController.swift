//
//  LoginViewController.swift
//  Remembral
//
//  Created by Aayush Malhotra on 11/27/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginEmail: UITextField!
    
    @IBOutlet weak var LoginPassword: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let email = KeychainWrapper.standard.string(forKey: "email"), let password = KeychainWrapper.standard.string(forKey: "password") {
//            signInandSegueToApp(email: email, password: password)
//        }
        
        self.LoginButton.layer.cornerRadius = 5; // this value vary as per your desire
        self.LoginButton.clipsToBounds = true;
    }
    

    @IBAction func OnLogin(_ sender: Any) {
        if let email = LoginEmail.text, let password = LoginPassword.text {
                signInandSegueToApp(email: email, password: password)
        }
    }

    @IBAction func OnRegister(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func signInandSegueToApp(email : String!, password: String!) {
        Auth.auth().signIn(withEmail: email, password: password, completion:
            { (result, error) in
                
                if error == nil {
                    KeychainWrapper.standard.set(email, forKey: "email")
                    KeychainWrapper.standard.set(password, forKey: "password")
                    FirebaseDatabase.sharedInstance.UpdateFromFirebase(completion: {
                        (isFinish) in
                        let userType = FirebaseDatabase.sharedInstance.userObj.type
                        if userType == "Patient" {
                            self.performSegue(withIdentifier: "toPatientApp", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "toCaretakerApp", sender: nil)
                        }
                    })
                } else {
                    print("Error signing in user.")
                }
        })
    }
}
