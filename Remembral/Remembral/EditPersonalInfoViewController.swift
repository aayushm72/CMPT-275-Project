//
//  EditPersonalInfoViewController.swift
//  Remembral
//
//  Created by trasmuss on 11/1/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit

class EditPersonalInfoViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientName.text = intitialPatientName
        patientAddress.text = intitialPatientAddress
        patientPhoneNumber.text = intitialPatientPhoneNumber
        caretakerName.text = intitialCaretakerName
        caretakerPhoneNumber.text = intitialCaretakerPhoneNumber

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let FirstViewController = segue.destination as? FirstViewController {
            FirstViewController.patientName = patientName.text!
            FirstViewController.patientAddress = patientAddress.text!
            FirstViewController.patientPhoneNumber = patientPhoneNumber.text!
            FirstViewController.caretakerName = caretakerName.text!
            FirstViewController.caretakerPhoneNumber = caretakerPhoneNumber.text!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
