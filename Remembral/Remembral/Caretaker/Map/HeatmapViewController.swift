//
//  HeatMapViewController.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-15.
//  Edited: Dean Fernandes, Aayush Malhotra
//
//
//  Caretaker Heat Map page
//  Known bugs:
//
//

import Foundation
import GoogleMaps
import FirebaseDatabase
import UIKit

class HeatmapViewController: UIViewController, GMSMapViewDelegate {
  private var mapView: GMSMapView!
  private var heatmapLayer: GMUHeatmapTileLayer!

  private var gradientColors = [ UIColor.green, UIColor.yellow, UIColor.red, UIColor.purple]
  private var gradientStartPoints = [0.1,0.4,0.7,1.0] as [NSNumber]

    // Load map view with a set frame
  override func loadView() {
    let camera = GMSCameraPosition.camera(withLatitude: -37.848, longitude: 145.001, zoom: 10)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    self.view = mapView
  }

    // Did the View controller load
  override func viewDidLoad() {
    // Set heatmap options.
    heatmapLayer = GMUHeatmapTileLayer()
    heatmapLayer.radius = 80
    heatmapLayer.opacity = 1.0
    heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                        startPoints: gradientStartPoints,
                                        colorMapSize: 256)
    addHeatmap()
  }

  // Get Firebase data and add it to the heatmap layer.
  func addHeatmap()  {
    var list = [GMUWeightedLatLng]()
    let ref = FirebaseDatabase.sharedInstance.locationRef
    let childRef = ref.child(FirebaseDatabase.sharedInstance.getSelectedPatientID())
    var isFirst = true
    var firstlat = CLLocationDegrees()
    var firstlng = CLLocationDegrees()
    childRef.observeSingleEvent(of: .value, with: {
        (snapshot: DataSnapshot) in
        for child in snapshot.children {
            let rData = (child as! DataSnapshot).value as? [String: Any]
            let lat = rData!["latitude"]
            let lng = rData!["longitude"]
            if isFirst {
                isFirst = false
                firstlat = rData!["latitude"] as! CLLocationDegrees
                firstlng = rData!["longitude"] as! CLLocationDegrees
            }
            let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
            list.append(coords)
        }
    self.heatmapLayer.clearTileCache()
    self.heatmapLayer.weightedData = list
    self.heatmapLayer.map = self.mapView
    let camera = GMSCameraPosition.camera(withLatitude: firstlat, longitude: firstlng, zoom: 10)
    self.mapView.camera = camera
    })
  }

// Find the location the user taps.
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
  }

}
