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

struct ContactPerson {
    
    // list of attribues for a contact
    var firstName : String
    var lastName : String
    var emailAddress : String
    var relation : String
    
    init(){
        firstName = "John"
        lastName = "Doe"
        emailAddress = "john.doe@jdmail.com"
        relation = "friend"
    }
    init(withFirstName first:String, lastName last:String, emailAddress email:String){
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
    }
    
}
