//
//  ContactPerson.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-24.
//  Edited: Dean Fernandes
//
//  Contact Person Class
//  Will be used in Version 3
//  Known bugs:
//
//

import UIKit

class ContactPerson: NSObject {
    
    // list of attribues for a contact
    var firstName : String
    var lastName : String
    var emailAddress : String
    
    // simpile initializer
    override init(){
        firstName = "John"
        lastName = "Doe"
        emailAddress = "john.doe@jdmail.com"
        super.init()
    }
    
    // initializer with passed in values
    init(withFirstName first:String, lastName last:String, emailAddress email:String){
        firstName = first
        lastName = last
        emailAddress = email
        super.init()
    }
    
}
