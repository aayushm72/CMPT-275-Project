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

class CaretakerMapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
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
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 49.276765, longitude: -122.917957, zoom: 24)
        let mapView = GMSMapView(frame: .zero)
       // let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        
        // Patient's Current Location Marker: Need to update Real time
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(49.276765, -122.917957)
        marker.title = "Patient name"
        marker.snippet = "Last Updated @ 5:00 pm"
        marker.map = mapView
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //self.view = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access location")
    }
    
}
