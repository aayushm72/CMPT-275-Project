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
import GoogleMaps

typealias XYPoint = (x:Double,y:Double)


struct LocationObj {
    var latitude:Double!
    var longitude:Double!
    var time:Double!
    var weight:Double?
    init(latitude: Double, longitude: Double, time: Double){
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.weight = 1.0;
    }
    init (coord: CLLocationCoordinate2D, time: Double, weight: Double){
        self.latitude = coord.latitude
        self.longitude = coord.longitude
        self.time = time
        self.weight = weight
    }
    func asCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    func distance(other: LocationObj) -> Double {
        let R = 6378.137; // Radius of earth in KM
        let lat1  = latitude!;
        let lat2  = other.latitude!;
        let lon1 = longitude!;
        let lon2 = other.longitude!;
        
        let dLat = lat2 * Double.pi / 180 - lat1 * Double.pi / 180;
        let dLon = lon2 * Double.pi / 180 - lon1 * Double.pi / 180;
        let a = abs( sin(dLat/2) * sin(dLat/2) +
            cos(lat1 * Double.pi / 180) * cos(lat2 * Double.pi / 180) *
            sin(dLon/2) * sin(dLon/2) );
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        let d = R * c;
        return d * 1000; // meters
    }
    mutating func averageWith(other: LocationObj) {
        self.latitude = (self.latitude + other.latitude) / 2
        self.longitude = (self.longitude + other.longitude) / 2
    }
    func getInMeters() -> (x: Double, y:Double) {
        let mPerDegLat =  111132.954 - 559.822 * cos( 2 * latitude ) + 1.175 * cos( 4 * latitude)
        let mPerDegLong = 111132.954 * cos ( latitude )
        return (x: latitude * mPerDegLat, y: longitude * mPerDegLong)
    }
    func addMeters(x: Double, y: Double) -> LocationObj{
        let mPerDegLat =  111132.954 - 559.822 * cos( 2 * latitude ) + 1.175 * cos( 4 * latitude)
        let mPerDegLong = 111132.954 * cos ( latitude )
        return LocationObj(latitude: self.latitude + x / mPerDegLat, longitude: self.longitude + y / mPerDegLong, time: self.time)
    }
    func asXY() -> XYPoint{
        return (x: self.longitude, y:self.latitude)
    }
}

class LocationServicesHandler : NSObject {
    struct LOCATION_SETTINGS {
        static let UPDATE_DISTANCE = 10.0
    }
    
    override init(){
        super.init()
    }
    static let min_radius = 300.0
    
    static func generateFence(forUser: String, forLocations: [LocationObj], mapView: GMSMapView)-> [XYPoint]{
        /*newList.sort { (lhs: LocationObj, rhs: LocationObj) -> Bool in
            return lhs.latitude < rhs.latitude || (lhs.latitude == rhs.latitude && lhs.longitude < rhs.longitude)
        }*/
        
        /*for location in newList{
            let newCircle = GMSCircle(position: location.asCoordinate(), radius: min_radius)
                newCircle.strokeColor = .red
                newCircle.map = mapView
        }*/
        let firstReduce = LocationServicesHandler.simplifyLocationList(locationList: forLocations)
        let groupedLocations = LocationServicesHandler.reduceLocationListOverlap(locationList: firstReduce)
        
        
        var rectPoints = [(x:Double, y:Double)]()
        for location in groupedLocations{
            let radius = min_radius * (location.weight ?? 1.0)
            rectPoints.append(location.addMeters(x: radius, y: radius).asXY())
            rectPoints.append(location.addMeters(x: radius, y: -radius).asXY())
            rectPoints.append(location.addMeters(x: -radius, y: -radius).asXY())
            rectPoints.append(location.addMeters(x: -radius, y: radius).asXY())
        }
        
        
        let result = generateConcaveHull(locationList: rectPoints)
        print(result)
        let FinalPolygon = GMSMutablePath()
        
        for index in 0..<result.count-1{
            let point = result[index]
            var radius = Double(1000 - index * 120)
            if radius < 100{
                radius = 100
            }
            let newLocation = CLLocationCoordinate2D(latitude: point.y, longitude: point.x)
            FinalPolygon.add(newLocation)
        }
        let polygon = GMSPolygon(path: FinalPolygon)
            polygon.fillColor = UIColor(red: 0.8, green: 0.5, blue: 0, alpha: 0.3);
            polygon.strokeColor = .black
            polygon.strokeWidth = 2
            polygon.map = mapView
        
        return result
    }
    
    static func convertToPointList(locationList: [LocationObj]) -> [(x:Double,y:Double)]{

        var newPoints = [(x:Double, y:Double)]()
        for location in locationList{
            newPoints.append(location.getInMeters())
        }
        return newPoints
    }
    static func reduceLocationListOverlap(locationList: [LocationObj]) -> [LocationObj]{
        var newList = locationList
        newList.sort { (lhs: LocationObj, rhs: LocationObj) -> Bool in
            return lhs.latitude < rhs.latitude || (lhs.latitude == rhs.latitude && lhs.longitude < rhs.longitude)
         }
        return simplifyLocationList(locationList: newList)
    }
    static func simplifyLocationList(locationList: [LocationObj]) -> [LocationObj]{
        var runningSize = 1.0
        var newList = locationList
        var retList = [LocationObj]()
        while(newList.count > 1) {
            let location = newList[0]
            let other = newList[1]
            let distanceDiff = location.distance(other: newList[1])
            
            if distanceDiff < min_radius {
                if location.longitude == other.longitude && location.latitude == location.latitude{
                    runningSize *= 0.9
                }
                else {
                    newList[0].averageWith(other: other)
                    runningSize += 0.5 * distanceDiff / min_radius
                }
                newList.remove(at: 1)
            }
            else if distanceDiff < min_radius * 3{
                runningSize += 0.5 * distanceDiff / (min_radius * runningSize)
                newList.remove(at: 1)
            }
            else {
                //GMSCircle(position: location.asCoordinate(), radius: min_radius * runningSize).map = mapView
                let newEl = LocationObj(coord: location.asCoordinate(), time: location.time, weight: runningSize)
                retList += [newEl]
                newList.remove(at: 0)
                runningSize = 1
            }
        }
        let newEl = LocationObj(coord: newList[0].asCoordinate(), time: newList[0].time, weight: runningSize)
        retList += [newEl]
        return retList
        //GMSCircle(position: newList[0].asCoordinate(), radius: min_radius * runningSize).map = mapView
    }
    static func isPointInsideFence(currentLocation: CLLocationCoordinate2D, fence: [XYPoint]) -> Bool{
        return pointInPolygon(pointCheck: (x: currentLocation.longitude, y: currentLocation.latitude), pointList: fence)
    }
    
    static func generateConcaveHull (locationList: [XYPoint]) -> [XYPoint]{
        //http://repositorium.sdum.uminho.pt/bitstream/1822/6429/1/ConcaveHull_ACM_MYS.pdf
        var workingSet = locationList
        var hull = [XYPoint]()
        workingSet.sort { (lhs: XYPoint, rhs: XYPoint) -> Bool in
            return (lhs.y < rhs.y)
        }
        
        let firstPoint = workingSet[0]
        workingSet.remove(at: 0)
        hull.append(firstPoint)
        let k = 15
        var currentPoint = firstPoint
        var step = 1
        var previousAngle = 0.0
        while (currentPoint != firstPoint || step == 1){
            print(currentPoint)
            print("Previous angle is", previousAngle)
            if step == 4{
                workingSet.insert(firstPoint, at: 0)
            }
            sortByDistance(firstPoint: currentPoint, otherPoints: &workingSet)
            var test2 = workingSet[0..<k]
            test2.sort(by: {
                var lhs = atan2($0.y - currentPoint.y, $0.x - currentPoint.x) - previousAngle
                var rhs = atan2($1.y - currentPoint.y, $1.x - currentPoint.x) - previousAngle
                if lhs < 0{
                    lhs += 2.0 * Double.pi
                }
                if rhs < 0{
                    rhs += 2.0 * Double.pi
                }
                return lhs > rhs
            })
            var nextPoint = XYPoint(0,0)
            for point in test2{
                print(atan2(point.y - currentPoint.y, point.x - currentPoint.x) - previousAngle)
                if (!lineCrossesList(firstLine: [currentPoint, point], otherLines: hull)){
                    nextPoint = point
                    break
                }
            }
            if nextPoint == (x:0.0, y:0.0){
                print("Did not find a point")
                hull.append(test2[0])
                return hull
            }
            hull.append(nextPoint)
            workingSet.removeAll { $0 == nextPoint}
            currentPoint = nextPoint
            previousAngle = atan2(hull[step-1].y - hull[step].y, hull[step-1].x - hull[step].x)
            print(nextPoint, previousAngle)
            step += 1
            print(step , "\n\n\n\n")
        }
        print(workingSet.count)
        print(workingSet)
        return hull
    }
    static func sortByDistance(firstPoint: XYPoint, otherPoints: inout [XYPoint]){
        otherPoints.sort(by: {distance2(p1: firstPoint, p2: $0) < distance2(p1: firstPoint, p2: $1)})
    }
    static func distance(p1: XYPoint, p2: XYPoint) -> Double{
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return (sqrt(x*x + y*y))
    }
    static func distance2(p1: XYPoint, p2: XYPoint) -> Double{
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return x*x+y*y
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
    static func readLocations(forID: String, startingPoint: Double = 0.0, endingPoint: Double = getNewEndingPoint(), completion: (([LocationObj]) -> Void)?){
        let userLocationData = FirebaseDatabase.sharedInstance.locationRef.child(forID)
        userLocationData.queryOrdered(byChild: "time").queryStarting(atValue: startingPoint).queryEnding(atValue: endingPoint).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
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
    static func getNewEndingPoint() -> Double{
        return NSDate().timeIntervalSince1970.rounded() + 1
    }
    static func pointInPolygon(pointCheck: XYPoint, pointList: [XYPoint])-> Bool{
        var count = 0
        for index in 0..<pointList.count-1 {
            
            if rayIntersectLine(rayOrigin: pointCheck, rayDirection: (x: 1, y:0), p1: pointList[index], p2: pointList[index+1]) != nil{
                count += 1
            }
        }
        //If there are an odd number of intersections that means the point is inside the polygon
        return count % 2 == 1
        
    }
    static private func rayIntersectLine(rayOrigin: XYPoint, rayDirection: XYPoint, p1: XYPoint, p2: XYPoint) -> Double?{
        //Stackoverflow
        let v1 = (x: rayOrigin.x - p1.x, y: rayOrigin.y - p1.y)
        let v2 = (x: p2.x - p1.x, y: p2.y - p1.y)
        let v3 = (x: -rayDirection.y, y: rayDirection.x)
        
        let dot = v2.x * v3.x + v2.y * v3.y
        if (abs(dot) < 0.000001){
            return nil
        }
        
        // 2d crossproduct / dot
        let t1 = ((v2.x * v1.y) - (v2.y * v1.x)) / dot
        let t2 = (v1.x * v3.x + v1.y * v3.y) / dot
        if (t1 >= 0.0 && (t2 >= 0.0 && t2 <= 1.0)){
            return t1;
        }
        return nil
    }
    static func lineCrossesList(firstLine: [XYPoint], otherLines: [XYPoint])->Bool{
        if otherLines.count < 3 {
            return false
        }
        //Ignore the previously created line, because the new line will always intersect it
    
        for index in 0..<otherLines.count-2{
            let otherLine = [otherLines[index], otherLines[index + 1]]
            if lineCrossesLine(firstLine: firstLine, secondLine: otherLine){
                return true
            }
        }
        return false;
    }
    static func lineCrossesLine(firstLine: [XYPoint], secondLine: [XYPoint])-> Bool{
        let v1x1 = firstLine[0].x
        let v1y1 = firstLine[0].y
        let v1x2 = firstLine[1].x
        let v1y2 = firstLine[1].y
        let v2x1 = secondLine[0].x
        let v2y1 = secondLine[0].y
        let v2x2 = secondLine[1].x
        let v2y2 = secondLine[1].y

        var d1, d2 : Double
        var a1, a2, b1, b2, c1, c2 : Double
        
        a1 = v1y2 - v1y1;
        b1 = v1x1 - v1x2;
        c1 = (v1x2 * v1y1) - (v1x1 * v1y2);
        
        d1 = (a1 * v2x1) + (b1 * v2y1) + c1;
        d2 = (a1 * v2x2) + (b1 * v2y2) + c1;
        
        if (d1 > 0 && d2 > 0){
            return false;
        }
        if (d1 < 0 && d2 < 0){
            return false;
        }
        
        a2 = v2y2 - v2y1;
        b2 = v2x1 - v2x2;
        c2 = (v2x2 * v2y1) - (v2x1 * v2y2);

        d1 = (a2 * v1x1) + (b2 * v1y1) + c2;
        d2 = (a2 * v1x2) + (b2 * v1y2) + c2;

        if (d1 > 0 && d2 > 0){
            return false;
        }
        if (d1 < 0 && d2 < 0){
            return false;
        }

        if ((a1 * b2) - (a2 * b1) == 0.0) {
            return true; //Colinear
        }
            
        // If they are not collinear, they must intersect in exactly one point.
        return true;
    }
    
}
