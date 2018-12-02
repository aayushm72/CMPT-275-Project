//
//  ReminderViewController.swift
//  Remembral
//
//Team: Group 2
//  Created: Aayush Malhotra on 11/1/18.
//  Edited: Alwin Leong
//
// ******For Reminders Page
// Will show a table of reminders determined by the viewWillAppear
// viewWillAppear can be overriden to have the table show different reminders.
//  Known bugs:
//
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var reminders = [Reminder]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // Did the screen load.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Declare number of columns for Reminder table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //Declare number of rows for Reminder table by looking at the number of rows in the database table for Reminders
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    // Declare table view, make cells by accessing data from database for all attributes for remiders. If status of Reminder
    // is completed, it is grey. If the status is not completed, it is white. The toggle for the status is the done button.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ReminderTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReminderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ReminderTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let reminderData = reminders[indexPath.row]
        
        var labelText = "Task: " + reminderData.description as String + "\n"
        let dateToday = Date()
        let dayOfToday = Calendar.current.dateComponents([.day], from: dateToday).day
        
        labelText.append("Time: ")
        
        if dayOfToday == reminderData.getDay() {
            labelText.append("Today")
        }
        else if dayOfToday == reminderData.getDay() - 1{
            labelText.append("Tomorrow")
        }
        else {
            let reminderDate = reminderData.getDateOf()
            labelText.append(reminderDate.getMonthName() + " ")
            labelText.append(String(reminderData.getDay()))
        }
        labelText.append(" @ ")
        labelText.append(String(format: "%2d", reminderData.getHour()))
        labelText.append(":")
        labelText.append(String(format: "%02d", reminderData.getMinute()))
        
        labelText.append("\nSet by: ")
        labelText.append(reminderData.sender as String)
        
        //labelText.append("\nStatus: " )
        //labelText.append(reminderData.status ? "Complete" : "NotComplete")
        
        cell.ReminderLabel.text = labelText
        cell.reminderDBKey = reminderData.databaseKey
        cell.delegate = self
        
        if (reminderData.status == true){
            cell.isCompleted()
        } else {
            cell.isNotComplete()
        }
        
        cell.doneButton?.layer.cornerRadius = 5
        cell.doneButton?.clipsToBounds = true
        
        if (FirebaseDatabase.sharedInstance.userObj.type == "Caretaker"){
            cell.doneButton?.isHidden = true
        }
        
        return cell
    }
    
    // Show updates for table.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateReminderTable()
    }
    
    //Check if there are updates for table.
    func updateReminderTable(){
        FirebaseDatabase.sharedInstance.updateRemindersThen(completion: { (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        })
    }
    
    // Is the screen loaded.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // Is there any memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
