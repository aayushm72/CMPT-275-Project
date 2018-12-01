//
//  AddPatientViewController.swift
//  Remembral
//
//Team: Group 2
//  Created by Alwin Leong on 11/28/18.
//  Edited: Alwin Leong
//
// For Add Patient View
//  Known bugs:
//
//


import UIKit
import FirebaseDatabase

class AddPatientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var foundPatients = [ContactPerson]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var patientNameTextField: UITextField!
    
    let cellIdentifier = "PatientTableViewCell"
    
    // Return number of rows for table to setup table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundPatients.count
    }
    
    //Set up table to view all using the searchForPatients function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactNameOnlyTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PatientTableViewCell.")
        }
        let patientObj = foundPatients[indexPath.row]
        cell.cellLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 1)
        cell.cellLabel.heightAnchor.constraint(equalToConstant: 60)
        cell.textLabel?.text = patientObj.fullName
        return cell
    }
    
    // Did screen load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ContactNameOnlyTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    // Find all patients that are available for the caretaker to choose. Specify a patient by searching for a name.
    @IBAction func searchForPatients(_ sender: Any) {
        let nameToSearch = patientNameTextField.text
        
        FirebaseDatabase.sharedInstance.usersRef.queryOrdered(byChild: "name").queryStarting(atValue: nameToSearch).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            self.foundPatients.removeAll()
            for snap in snapshot.children{
                
                if let info = (snap as! DataSnapshot).value as? [String:Any]{
                    if (info["type"] as? String) == "Caretaker"{
                        continue
                    }
                    let key = (snap as! DataSnapshot).key
                    if FirebaseDatabase.sharedInstance.contactList.contains(where: {$0.identifier == key}){
                        continue
                    }
                    let patientFound = ContactPerson(
                        fullName: info["name"] as? String,
                        phoneNum: info["phNo"] as? String,
                        identifier: key
                    )
                    
                self.foundPatients.append(patientFound)
                    
                }
                self.tableView.reloadData()
            }
        })
            
        }
    
    // Setup number of rows based on number of patients that the search result has found.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < foundPatients.count{
    //        let foundP = foundPatients[indexPath.row]
   //         FirebaseDatabase.sharedInstance.contactList.append((key: foundP.identifier, name: foundP.fullName))
   //         ContactPerson.addContact(contactUID: foundP.identifier)
            self.performSegue(withIdentifier:"UnwindToViewAllPatient", sender: self)
        }
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

