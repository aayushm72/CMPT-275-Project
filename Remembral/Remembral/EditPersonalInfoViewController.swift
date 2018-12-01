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
class EditPersonalInfoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "NameOnlyCell";
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDatabase.sharedInstance.contactList.count
    }
    
    // Set up table view for Contacts. When a Contact is selected, highlight it in green.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactNameOnlyTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactNameOnlyTableViewCell.")
        }
        cell.textLabel?.text = FirebaseDatabase.sharedInstance.contactList[indexPath.row].fullName
        if caretakerTableSelected == indexPath.row{
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
    
    // Determine number of rows for table view. Load the updated amount.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        caretakerTableSelected = indexPath.row;
        tableView.reloadData()
    }
    
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var patientAddress: UITextField!
    @IBOutlet weak var patientPhoneNumber: UITextField!
    @IBOutlet weak var caretakerName: UITextField!
    @IBOutlet weak var caretakerPhoneNumber: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var caretakerTable: UITableView!
    var caretakerTableSelected = -1;
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
        
        caretakerTable.register(ContactNameOnlyTableViewCell.self , forCellReuseIdentifier: cellIdentifier )
    
        doneButton.layer.cornerRadius = 10
        doneButton.clipsToBounds = true
        
    }
    
    //Ensure screen appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // Was there memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Update all the fields with the original information from the database.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let FirstViewController = segue.destination as? PatientsHomeViewController {
            
            var caretakerName_str = caretakerName.text ?? ""
            var caretakerPhone_str = caretakerPhoneNumber.text ?? ""
            
            if caretakerTableSelected >= 0 &&
                caretakerTableSelected < FirebaseDatabase.sharedInstance.contactList.count{
                let selectedContact = FirebaseDatabase.sharedInstance.contactList[caretakerTableSelected];
                caretakerName_str = selectedContact.fullName as String
                caretakerPhone_str = selectedContact.phoneNum as String
            }
            
            user.name = patientName.text!
            user.address = patientAddress.text!
            user.phNo = patientPhoneNumber.text!
            user.caretakerName = caretakerName_str
            user.caretakerPhNo = caretakerPhone_str
            FirebaseDatabase.sharedInstance.setUserData(arg: user)
            
            FirstViewController.patientName = patientName.text!
            FirstViewController.patientAddress = patientAddress.text!
            FirstViewController.patientPhoneNumber = patientPhoneNumber.text!
            

            FirstViewController.caretakerName = caretakerName_str
            //caretakerName.text!
            FirstViewController.caretakerPhoneNumber = caretakerPhone_str
            //caretakerPhoneNumber.text!
        }
    }
    // Ensure table appears.
    override func viewWillAppear(_ animated: Bool) {
        caretakerTable.reloadData()
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
        performSegue(withIdentifier: "UnwindToHomeScreen", sender: self)
    }
}
