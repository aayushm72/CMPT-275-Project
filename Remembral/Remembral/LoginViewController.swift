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

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var LoginEmail: UITextField!
    
    @IBOutlet weak var LoginPassword: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = KeychainWrapper.standard.string(forKey: "email"), let password = KeychainWrapper.standard.string(forKey: "password") {
           signInandSegueToApp(email: email, password: password)
        }
        
        self.LoginButton.layer.cornerRadius = 5; // this value vary as per your desire
        self.LoginButton.clipsToBounds = true;
        
        LoginEmail.delegate = self
        LoginPassword.delegate = self
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginButton.isEnabled = true
    }


    @IBAction func OnLogin(_ sender: Any) {
        if (LoginEmail.text?.isEmpty)! || (LoginPassword.text?.isEmpty)! {
            let errorMessage = UIAlertController(title: "Incomplete Info", message: "Fill in a valid Email and Password to sign in.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            errorMessage.addAction(OKAction)
            self.present(errorMessage, animated: true, completion: nil)
            return
        }
        
        if let email = LoginEmail.text, let password = LoginPassword.text {
                signInandSegueToApp(email: email, password: password)
        }
    }

    @IBAction func OnRegister(_ sender: Any) {
        if (LoginEmail.text?.isEmpty)! || (LoginPassword.text?.isEmpty)! {
            let errorMessage = UIAlertController(title: "Incomplete Info", message: "Fill in a valid Email and Password that you would like to register.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            errorMessage.addAction(OKAction)
            self.present(errorMessage, animated: true, completion: nil)
            return
        }
        
        self.performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RegisterViewController = segue.destination as? RegisterViewController {
            RegisterViewController.email = LoginEmail.text
            RegisterViewController.password = LoginPassword.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == LoginEmail){
            LoginPassword.becomeFirstResponder()
        } else if (textField == LoginPassword){
            LoginButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    func signInandSegueToApp(email : String!, password: String!) {
        LoginButton.isEnabled = false
        Auth.auth().signIn(withEmail: email, password: password, completion:
            { (result, error) in
                
                if error == nil {
                    KeychainWrapper.standard.set(email, forKey: "email")
                    KeychainWrapper.standard.set(password, forKey: "password")
                    FirebaseDatabase.sharedInstance.UpdateFromFirebase(completion: {
                        (isFinish) in
                        let userType = FirebaseDatabase.sharedInstance.userObj.type
                        if userType == "Patient" {
                            FirebaseDatabase.sharedInstance.LoadContacts(){ _ in
                                self.performSegue(withIdentifier: "toPatientApp", sender: nil)
                            }
                        } else {
                            FirebaseDatabase.sharedInstance.LoadContacts(){ _ in
                                self.performSegue(withIdentifier: "toCaretakerApp", sender: nil)
                            }
                        }
                    })
                } else {
                    let errorMessage = UIAlertController(title: "Failed", message: "The sign in attempt failed. Please try again.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default)
                    errorMessage.addAction(OKAction)
                    self.present(errorMessage, animated: true, completion: nil)
                    self.LoginButton.isEnabled = true
                    return
                }
        })
    }
    
}
