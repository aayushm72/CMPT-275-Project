//
//  EditPersonalInfoViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by trasmuss on 11/1/18.
//  Edited: Tyler Rasmussen, Alwin Leong
//
//  For editing the personal information of the user
//  Known bugs:
//
//

import UIKit

// Edit Personal Information for Patient
class EditPersonalInfoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var patientAddress: UITextField!
    @IBOutlet weak var patientPhoneNumber: UITextField!
    @IBOutlet weak var caretakerName: UITextField!
    @IBOutlet weak var caretakerPhoneNumber: UITextField!
    //Temp vars to load textfield after the view has loaded. Set by FirstViewController only.
    var intitialPatientName:String = "Name"
    var intitialPatientAddress:String = "Address"
    var intitialPatientPhoneNumber:String = "PhoneNumber"
    var intitialCaretakerName:String = "CName"
    var intitialCaretakerPhoneNumber:String = "CPhoneNumber"
    var user = User()
    
    // Did the screen load
    override func viewDidLoad() {
        super.viewDidLoad()
        patientName.text = intitialPatientName
        patientAddress.text = intitialPatientAddress
        patientPhoneNumber.text = intitialPatientPhoneNumber
        caretakerName.text = intitialCaretakerName
        caretakerPhoneNumber.text = intitialCaretakerPhoneNumber
        
        
        patientName.delegate = self
        patientAddress.delegate = self
        patientPhoneNumber.delegate = self
        caretakerName.delegate = self
        caretakerPhoneNumber.delegate = self
    }

    // Was there memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Update all the fields with the original information from the database.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let FirstViewController = segue.destination as? PatientsHomeViewController {
            user.name = patientName.text!
            user.address = patientAddress.text!
            user.phNo = patientPhoneNumber.text!
            user.caretakerName = caretakerName.text!
            user.caretakerPhNo = caretakerPhoneNumber.text!
            FirebaseDatabase.sharedInstance.setUserData(arg: user)
            
            FirstViewController.patientName = patientName.text!
            FirstViewController.patientAddress = patientAddress.text!
            FirstViewController.patientPhoneNumber = patientPhoneNumber.text!
            FirstViewController.caretakerName = caretakerName.text!
            FirstViewController.caretakerPhoneNumber = caretakerPhoneNumber.text!
        }
    }
    
    // First touch
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Remove text screen.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Submit data entered by user to the database.
    @IBAction func Done(_ sender: UIButton) {
        user.name = patientName.text!
        user.address = patientAddress.text!
        user.phNo = patientPhoneNumber.text!
        user.caretakerName = caretakerName.text!
        user.caretakerPhNo = caretakerPhoneNumber.text!
        FirebaseDatabase.sharedInstance.setUserData(arg: user)
        performSegue(withIdentifier: "UnwindToHomeScreen", sender: self)
    }
}
