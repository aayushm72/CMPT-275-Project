//
//  ContactsViewController.swift
//  Remembral
//
//Team: Group 2
//  Created: Aayush Malhotra on 11/1/18.
//  Edited:
//  Alwin
//
// *Contacts Page
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var contactList = [ContactPerson]()
    
    @IBOutlet weak var contactTableView: UITableView!
    var contactStore = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //contactList.append(ContactPerson())
        
        //contactList.append(ContactPerson(fullName: "name last", emailAddress: "mail", relation: "friend"))
        
        contactTableView.rowHeight = 80
        /*
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authStatus {
        case .authorized:
            getContacts()
        case .denied, .notDetermined, .restricted:
            
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, accessError) -> () in
                if access {
                    self.getContacts()
                } else {
                    if authStatus == .denied {
                        DispatchQueue.main.async {
                            let msg = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            print(msg)
                        }
                    }
                }
            })
        }*/
    }
    func getContacts(){
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try self.contactStore.enumerateContacts(with: request, usingBlock: {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                /*let mail = (contact.emailAddresses.count > 0 ? contact.emailAddresses[0].value : "none") as String
                let relation = (contact.contactRelations.count > 0 ? contact.contactRelations[0].value.name : "none")*/
                self.contactList.append(ContactPerson(fullName: contact.givenName + " " + contact.familyName, emailAddress: "mail" , relation: "friend"))
                print(contact)
                self.contactTableView.reloadData()
            })
        }
        catch {
            print("unable to fetch contacts")
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDatabase.sharedInstance.contactList.count // contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContactTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        let contactData = FirebaseDatabase.sharedInstance.contactList[indexPath.row]
        
        cell.nameLabel.text = contactData.fullName
        cell.relationLabel.text = contactData.relation

        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactTableView.reloadData()
    }
    func updateContactTable(){

    }
    
    @IBAction func UnwindToContacts(_ segue: UIStoryboardSegue) {
        
    }
}

