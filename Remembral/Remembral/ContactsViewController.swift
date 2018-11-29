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

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var contactList = [ContactPerson]()
    
    @IBOutlet weak var contactTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactList.append(ContactPerson())
        
        contactList.append(ContactPerson(fullName: "name last", emailAddress: "mail", relation: "friend"))
        
        contactTableView.rowHeight = 80
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContactTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        let contactData = contactList[indexPath.row]
        
        cell.nameLabel.text = contactData.fullName
        cell.relationLabel.text = contactData.relation

        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContactTable()
    }
    func updateContactTable(){

    }
    

}

