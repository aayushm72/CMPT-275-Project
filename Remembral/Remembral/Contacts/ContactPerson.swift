//
//  ContactPerson.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-24.
//  Edited: Dean Fernandes
//  Alwin
//
//  Contact Person Class
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit
import FirebaseAuth

struct ContactPerson {
    
    // list of attribues for a contact
    var fullName : String!
    var emailAddress : String?
    var relation : String?
    var phoneNum: String!
    var identifier: String!
    
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
    static func addContact(contactUID: String){
        let nextElement = FirebaseDatabase.sharedInstance.contactsRef.child((Auth.auth().currentUser?.uid)!).childByAutoId()
        nextElement.setValue(contactUID)
    }
}
