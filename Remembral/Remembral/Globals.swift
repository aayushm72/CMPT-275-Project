//
//  Globals.swift
//  Remembral
//
//  Created by Alwin Leong on 10/31/18.
//  Copyright © 2018 Aayush Malhotra. All rights reserved.
//

enum UserTypeEnum {
    case UNKNOWN
    case PATIENT
    case CARETAKER
}


class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var UserType = UserTypeEnum.UNKNOWN
    var reminder = [ReminderData]()

    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}

struct ReminderData{
    var time: Int
    var desc: String
    init(gTime: Int, Description:String){
        time = gTime
        desc = Description
    }
}

