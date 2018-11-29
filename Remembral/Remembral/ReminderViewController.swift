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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
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
        labelText.append("\nStatus: " )
        
        labelText.append(reminderData.status ? "Complete" : "NotComplete")
        
        cell.ReminderLabel.text = labelText
        cell.reminderDBKey = reminderData.databaseKey
        cell.delegate = self
        
        if (reminderData.status == true){
            cell.backgroundColor =  UIColor.lightGray
            cell.doneButton?.isHidden = true
        } else {
            cell.backgroundColor = UIColor.white
            cell.doneButton?.isHidden = false
        }
        
        if (FirebaseDatabase.sharedInstance.userObj.type == "Caretaker"){
            cell.doneButton?.isHidden = true
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateReminderTable()
    }
    func updateReminderTable(){
        FirebaseDatabase.sharedInstance.updateRemindersThen(completion: { (dict) in
            self.reminders = dict
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
