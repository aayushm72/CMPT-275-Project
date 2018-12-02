//
//  LoginViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Aayush Malhotra on 11/27/18.
//  Edited: Aayush Malhotra
//
// For Login View
//  Known bugs:
//
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var LoginEmail: UITextField!
    
    @IBOutlet weak var LoginPassword: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var loginBeingAttempted = false
    
    // Function determines if screen is loaded. It then asks the user to requests for username and password.
    // It also sets up the log in button.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = KeychainWrapper.standard.string(forKey: "email"), let password = KeychainWrapper.standard.string(forKey: "password") {
            loginBeingAttempted = true
           signInandSegueToApp(email: email, password: password)
        }
        
        self.LoginButton.layer.cornerRadius = 5; // this value vary as per your desire
        self.LoginButton.clipsToBounds = true;
        
        LoginEmail.delegate = self
        LoginPassword.delegate = self
        

    }

    // Show login button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.triggerFieldInteractibility()
    }


    // Provides error or success messages depending on if the user has filled in correct or incorrect data for login page.
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

    // Provides error message informing the user that they need to provide an email address and passowrd to register for the app.
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
    
    // Prepare the email address and password for the register screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let RegisterViewController = segue.destination as? RegisterViewController {
            RegisterViewController.email = LoginEmail.text
            RegisterViewController.password = LoginPassword.text
        }
    }
    
    // Function to deal with first touch
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Function to check if text fiel should apear for both the textfields in the screen.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == LoginEmail){
            LoginPassword.becomeFirstResponder()
        } else if (textField == LoginPassword){
            LoginButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
    // If signin successfull, then move to paient/caretakers homepage. Show them the regular home page based on if they are caretaker or patient.
    // If sign in unsuccessful, then asked them to try to login again with the right information or after connecting to internet.
    func signInandSegueToApp(email : String!, password: String!) {
        LoginButton.isEnabled = false
        Auth.auth().signIn(withEmail: email, password: password, completion:
            { (result, error) in
                self.loginBeingAttempted = false
                if error == nil {
                    KeychainWrapper.standard.set(email, forKey: "email")
                    KeychainWrapper.standard.set(password, forKey: "password")
                    FirebaseDatabase.sharedInstance.UpdateFromFirebase(completion: {
                        (isFinish) in
                        let userType = FirebaseDatabase.sharedInstance.userObj.type
                        self.LoginEmail.text = ""
                        self.LoginPassword.text = ""
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
                    self.triggerFieldInteractibility()
                    return
                }
        })
    }
    
//Used when logging in to prevent user from pressing any fields
    func triggerFieldInteractibility(){
        LoginEmail.isEnabled = !loginBeingAttempted
        LoginPassword.isEnabled = !loginBeingAttempted
        LoginButton.isEnabled = !loginBeingAttempted
        registerButton.isEnabled = !loginBeingAttempted
    }
    
}
