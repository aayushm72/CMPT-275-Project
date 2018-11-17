//
//  HeatMapViewController.swift
//  Remembral
//
//  Team: Group 2
//  Created by Dean Fernandes on 2018-11-15.
//  Edited: Dean Fernandes
//
//
//  Caretaker Map page
//  Will be used in Version 2
//  Known bugs:
//
//


/* Copyright (c) 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import GoogleMaps
import FirebaseDatabase
import UIKit

class HeatmapViewController: UIViewController, GMSMapViewDelegate {
  private var mapView: GMSMapView!
  private var heatmapLayer: GMUHeatmapTileLayer!

    private var gradientColors = [UIColor.yellow, UIColor.green, UIColor.red, UIColor.purple]
  private var gradientStartPoints = [0.1,0.4,0.7,1.0] as [NSNumber]

  override func loadView() {
    let camera = GMSCameraPosition.camera(withLatitude: -37.848, longitude: 145.001, zoom: 10)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    self.view = mapView
  }

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

  // Parse JSON data and add it to the heatmap layer.
  func addHeatmap()  {
    var list = [GMUWeightedLatLng]()
    let ref = FirebaseDatabase.sharedInstance.locationRef
    let childRef = ref.child("iKbAZiqWylPvVNkOLPlYfzyuzan2")
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


  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
  }

}
