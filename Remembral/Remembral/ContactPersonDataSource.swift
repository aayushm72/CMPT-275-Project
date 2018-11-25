//
//  ContactPersonDataSource.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-24.
//  Edited: Dean Fernandes
//
//  Contact Person Data Source Class
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit

class ContactPersonDataSource: NSObject {
    //Array of contacts
    let contacts = NSMutableArray()
    
    // class initializer
    override init(){
        super.init()
        loadContacts()
    }
    
    //Load contacts
    func loadContacts(){
        let sample1 = ContactPerson()
        contacts.add(sample1)
        let sample2 = ContactPerson(withFirstName: "Jason", lastName: "Doe", emailAddress: "Jason.Doe@jdmail.com")
        addContact(contact: sample2)
    }
    
    //Add a contact for explicit ContactPerson
    func addContact(contact c:ContactPerson){
        contacts.add(c)
    }
    
    // Return count of Contacts in array
    func countOfContacts() -> Int {
        return contacts.count
    }
    
    // Return a spefic contact given an index to the array of Contacts
    func contactAtIndex(index i: Int) -> ContactPerson{
        return contacts.object(at: i) as! ContactPerson
    }
    
}
