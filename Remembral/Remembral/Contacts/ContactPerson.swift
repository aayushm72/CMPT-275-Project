//
//  ContactPerson.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-24.
//  Edited: Dean Fernandes, Alwin Leong
//
//  Contact Person Class
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// Structure for a Contact
struct ContactPerson {
    
    // list of attribues for a contact
    var fullName : String!
    var emailAddress : String?
    var relation : String?
    var phoneNum: String!
    var identifier: String!
    var picture: UIImage!
    var address : String?
    
    // Test function.
    init(){
        fullName = "John Doe"
        emailAddress = "john.doe@jdmail.com"
        relation = "friend"
    }
    init(fullName: String?, phoneNum: String?, identifier: String?){
        self.fullName = fullName
        self.phoneNum = phoneNum
        self.identifier = identifier
    }
    init(fullName: String?, emailAddress: String?, relation: String?){
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.relation = relation
    }
    /*init(withFirstName first:String, lastName last:String, emailAddress email:String){
        firstName = first
        lastName = last
        emailAddress = email
        self.relation = "friend"
    }
    // initializer with passed in values
    
    init(withFirstName first:String, lastName last:String, emailAddress email:String, relation: String){
        firstName = first
        lastName = last
        emailAddress = email
        self.relation = relation
    }*/
    
    
    
    // Add contacts by reffering to database. Add all attributes that are in the Contact structure.
    static func addContact(contactToAdd: ContactPerson){
        let nextElement = FirebaseDatabase.sharedInstance.contactsRef.child((Auth.auth().currentUser?.uid)!).childByAutoId()
        let newContact = ["key": contactToAdd.identifier, "relation": contactToAdd.relation]
        nextElement.setValue(newContact)
        
        let otherPerson = FirebaseDatabase.sharedInstance.contactsRef.child(contactToAdd.identifier).childByAutoId()
        let setRelationAs = FirebaseDatabase.sharedInstance.getUserData().type == User.PATIENT ? "Patient" : "Unknown"
        let otherNewContact = ["key": (Auth.auth().currentUser?.uid)!, "relation": setRelationAs]

        otherPerson.setValue(otherNewContact)
    }
    
    // Remove contact by refering to database.
    static func deleteContact(contactToDelete: ContactPerson, completion: ((Bool)->Void)?){
        let ownID = (Auth.auth().currentUser?.uid)!
        let contactsRef = FirebaseDatabase.sharedInstance.contactsRef.child(ownID)
        contactsRef.queryOrdered(byChild: "key").queryEqual(toValue: contactToDelete.identifier).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            print(snapshot)
            if snapshot.childrenCount == 1{
                let singleProfile = snapshot.children.allObjects[0] as! DataSnapshot
                singleProfile.ref.removeValue()

                let otherContactRef =  FirebaseDatabase.sharedInstance.contactsRef.child(contactToDelete.identifier)
                otherContactRef.queryOrdered(byChild: "key").queryEqual(toValue: ownID).observeSingleEvent(of: .value, with: { (snapshot2: DataSnapshot) in
                    if snapshot2.childrenCount == 1{
                        let singleProfile2 = snapshot2.children.allObjects[0] as! DataSnapshot
                        singleProfile2.ref.removeValue()
                    }
                    completion? (true)                                                                                 
                })
            }
            else {
                completion? (false)
            }
        })
    }
    
}
