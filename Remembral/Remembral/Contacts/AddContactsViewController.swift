//
//  AddContactsViewController.swift
//  Remembral
//
//  Created by Alwin Leong on 11/29/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//
//
//  AddPatientViewController.swift
//  Remembral
//
//  Created by Alwin Leong on 11/28/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var foundPatients = [ContactPerson]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var contactNameTextField: UITextField!
    
    let cellIdentifier = "PatientTableViewCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PatientTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PatientTableViewCell.")
        }
        let patientObj = foundPatients[indexPath.row]
        cell.cellLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 1)
        cell.cellLabel.heightAnchor.constraint(equalToConstant: 60)
        cell.textLabel?.text = patientObj.fullName
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PatientTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchForContacts(_ sender: Any) {
        let nameToSearch = contactNameTextField.text
        
        FirebaseDatabase.sharedInstance.usersRef.queryOrdered(byChild: "name").queryStarting(atValue: nameToSearch).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            self.foundPatients.removeAll()
            for snap in snapshot.children{
                
                if let info = (snap as! DataSnapshot).value as? [String:Any]{
                    if (info["type"] as? String) == "Patient"{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < foundPatients.count{
            let alert = UIAlertController(title: "Set Relation", message: "Enter the relation of this user to you.", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "Caretaker"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                var foundP = self.foundPatients[indexPath.row]
                foundP.relation = textField.text
                FirebaseDatabase.sharedInstance.contactList.append(foundP)
                ContactPerson.addContact(contactToAdd: foundP)
                self.performSegue(withIdentifier:"UnwindToContacts", sender: self)
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            

        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }*/

    
}
