//
//  CaretakerMapViewController.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-12.
//  Edited: Dean
//  Alwin
//
//  Caretaker Map page
//  Will be used in Version 2
//  Known bugs:
//
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import FirebaseCore
import FirebaseDatabase

class CaretakerMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    var marker = GMSMarker()
    let mapView = GMSMapView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if CLLocationManager.locationServicesEnabled() {
            print("Location services are enabled")
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined{
                
                locationManager.requestWhenInUseAuthorization();
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Please enabled location services")
        }
        
        
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        
        // Patient's Current Location Marker: Need to update Real time
        marker.position = CLLocationCoordinate2DMake(0, 0)
        
        //Select a suitable image
        marker.icon = UIImage(named: "first")
        
        marker.map = mapView
        
        //Needs to be done using user id queries
        //
        let userID = "iKbAZiqWylPvVNkOLPlYfzyuzan2" //Auth.auth().currentUser?.uid
        FirebaseDatabase.sharedInstance.usersRef.child(userID).observe(.value) { (snapshot: DataSnapshot) in
            let userInfo = snapshot.value as! [String:Any]
            self.marker.title = userInfo["name"] as? String ?? "undefined"
        }
 ;
        
        //Updates marker whenever there's a location update.
        LocationServicesHandler.newestLocationUpdates(forID: userID) { (locationReturned) in
            self.marker.position.latitude = locationReturned.latitude
            self.marker.position.longitude = locationReturned.longitude
            self.marker.snippet = "Last Updated @ " + String(locationReturned.time)
            if self.mapView.selectedMarker != nil {
                let cameraUpdate = GMSCameraUpdate.setTarget((self.mapView.selectedMarker?.position)!)
                self.mapView.moveCamera(cameraUpdate)
            }
        }
       // locationManager(
        //let cameraMove = GMSCameraUpdate.setTarget((locationManager.location?.coordinate)!, zoom: 18)
        //mapView.moveCamera(cameraMove)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.mapView.selectedMarker == nil{
            let cameraMove = GMSCameraUpdate.setTarget((locationManager.location?.coordinate)!, zoom: 18)
            mapView.moveCamera(cameraMove)
        }
    }
   // func locationManager(_ manager: CLLocationManager, DidResumeLocationUpdates ) {
   //     return 0
   // }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access location")
    }
    
    func toggleHeatMap(){
        
    }

}
