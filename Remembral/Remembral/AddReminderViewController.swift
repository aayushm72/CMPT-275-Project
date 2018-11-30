//
//  AddReminderViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Dean Fernandes on 2018-10-30.
//  Edited: Dean Fernandes, Aayush Malhotra
//
//  Page for adding new reminders.
//  Known bugs:
//
//

import UIKit
import FirebaseAuth

class AddReminderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var taskDateTime: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let dataValues = ["No Recurrence", "Daily", "Weekly", "Monthly"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dataValues[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataValues.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let date = Date()
        taskDateTime.minimumDate = date
        taskDateTime.setValue(UIColor.white, forKey: "textColor")
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        var reminder = Reminder()
        let reciever = (FirebaseDatabase.sharedInstance.getUserData().type == User.CARETAKER ?
            FirebaseDatabase.sharedInstance.getSelectedPatientID() : Auth.auth().currentUser?.uid)
        reminder.sender = FirebaseDatabase.sharedInstance.userObj.name
        reminder.reciever = "Patient"
        reminder.description = taskDescription.text
        reminder.date = taskDateTime.date.timeIntervalSince1970
        reminder.recurrence = dataValues[pickerView.selectedRow(inComponent: 0)]
        FirebaseDatabase.sharedInstance.setReminder(arg: reminder, forID: reciever!)
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

