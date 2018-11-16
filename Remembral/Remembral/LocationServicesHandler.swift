//
//  LocationServicesHandler.swift
//  Remembral
//
//  Team: Group 2
//  Created by Alwin Leong on 10/18/18.
//  Edited:
//
//  Contains functions to aid with handling location database messages
//  Known bugs:
//  
//


import Foundation
import CoreLocation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

struct LocationObj {
    var latitude:Double!
    var longitude:Double!
    var time:Double!
}

class LocationServicesHandler : NSObject {
    struct LOCATION_SETTINGS {
        static let UPDATE_DISTANCE = 10.0
    }
    
    override init(){
        super.init()
    }
    static func sendData(location: CLLocation){
        let userID = Auth.auth().currentUser?.uid
        let locationRef = FirebaseDatabase.sharedInstance.locationRef
        let time = String(format:"%.01f", NSDate().timeIntervalSince1970);
        
        let values : [String:Any] = ["longitude": location.coordinate.longitude as Any,
                                     "latitude": location.coordinate.latitude as Any,
                                     "time": Double(time) as Any,
                                     ]
       // print(databasePath)
        print(values)
        let childRef = locationRef.child(userID!).childByAutoId()
        childRef.setValue(values)

    }
    static func newestLocationUpdates(forID: String, nextLocation: ((LocationObj) -> Void)?){
        let userID = forID //Auth.auth().currentUser?.uid
        
        let childRef = FirebaseDatabase.sharedInstance.locationRef.child(userID)
        childRef.queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot: DataSnapshot) in
                let locationInfo = snapshot.value as! [String:Any]
                let retVal = LocationObj(latitude: locationInfo["latitude"] as! Double,
                                         longitude: locationInfo["longitude"] as! Double,
                                         time: locationInfo["time"] as! Double )
                nextLocation?(retVal)
        })
    }
    static func getNewestLocation(forID: String, completion: ((LocationObj) -> Void)?){
        let userID = forID //Auth.auth().currentUser?.uid
        
        let childRef = FirebaseDatabase.sharedInstance.locationRef.child(userID)
        childRef.queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            print(snapshot.childrenCount)
            for snap in snapshot.children {
                let locationInfo = (snap as! DataSnapshot).value as! [String:Any]
                let retVal = LocationObj(latitude: locationInfo["latitude"] as! Double,
                                         longitude: locationInfo["longitude"] as! Double,
                                         time: locationInfo["time"] as! Double )
                completion? (retVal)
            }
        })
    }
    static func readLocations(startingPoint: Int, endingPoint: Int, completion: (([LocationObj]) -> Void)?){
        let locationRef = FirebaseDatabase.sharedInstance.locationRef
        let userID = Auth.auth().currentUser?.uid
        locationRef.child(userID!).queryOrdered(byChild: "time").queryStarting(atValue: startingPoint).queryEnding(atValue: endingPoint).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            var locationList = [LocationObj]()
            for snap in snapshot.children {
                let locationInfo = (snap as! DataSnapshot).value as! [String:Any]
                let singleLocation = LocationObj(latitude: locationInfo["latitude"] as! Double,
                                         longitude: locationInfo["longitude"] as! Double,
                                         time: locationInfo["time"] as! Double )
                locationList += [singleLocation]
            }
            completion? (locationList)
        })
    }

    
}
