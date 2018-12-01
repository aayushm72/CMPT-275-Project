//
//  ViewAllPatientsViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Alwin Leong on 11/28/18.
//  Edited: Alwin Leong
//
// For View All Patients
//  Known bugs:
//
//

import UIKit
import FirebaseDatabase

class ViewAllPatientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "PatientTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDatabase.sharedInstance.contactList.count
    }
    
    // Show all the Patients who have chosen the current user as Caretaker in the table. Selected patients will be highlighted in green.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactNameOnlyTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PatientTableViewCell.")
        }
        let patientKeyNamePair = FirebaseDatabase.sharedInstance.contactList[indexPath.row]
        
        cell.cellLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 1)
        cell.cellLabel.heightAnchor.constraint(equalToConstant: 60)
        
        cell.textLabel?.text = patientKeyNamePair.fullName
        if FirebaseDatabase.sharedInstance.selectedContacts == indexPath.row{
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
        
    }
    
    // Update the table view with the accurate number of patients.
    // Accurate patients are patients who have chosen the current user as caretaker.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print(FirebaseDatabase.sharedInstance.selectedContacts)
        FirebaseDatabase.sharedInstance.selectedContacts = index
        tableView.reloadData()
    }
    
    // Did screen load
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseDatabase.sharedInstance.LoadContacts(completion: nil)
        tableView.register(ContactNameOnlyTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func UnwindToViewAllPatient(_ segue: UIStoryboardSegue) {

    }
    
    // Ensure table view appears.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
