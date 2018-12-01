//
//  LocationServicesHandler.swift
//  Remembral
//
//  Team: Group 2
//  Created by Alwin Leong on 10/18/18.
//  Edited: Alwin Leong
//
//  Contains functions to aid with handling location database messages
//  Known bugs:
//  Implement hole detection in cluster to find empty spaces where the user has not visited.
//  Add these holes to the fence.
//
//  Completed: Method of find extra clusters.
//  Todo: Detect if cluster should be included.
//


import Foundation
import CoreLocation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import GoogleMaps

typealias XYPoint = (x:Double,y:Double)
typealias GeoFence = (inclusion: [XYPoint], exclusion: [XYPoint])


let emptyPoints = [XYPoint]()

/* This struct is used to store location data and allow for easy conversions using meters */

struct LocationObj {
    var latitude:Double!
    var longitude:Double!
    var time:Double!
    var weight:Double?
    
    // Initialize for Location Services
    init(latitude: Double, longitude: Double, time: Double){
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.weight = 1.0;
    }
    
    // Initialize for Location Services
    init (coord: CLLocationCoordinate2D, time: Double, weight: Double){
        self.latitude = coord.latitude
        self.longitude = coord.longitude
        self.time = time
        self.weight = weight
    }
    
    // Determine Coordinates
    func asCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    // Computing statistics for determining the distance to build fence.
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
    
    // Find the acerage given values.
    mutating func averageWith(other: LocationObj) {
        self.latitude = (self.latitude + other.latitude) / 2
        self.longitude = (self.longitude + other.longitude) / 2
    }
    
    // Convert to meters. Math involved.
    func getInMeters() -> (x: Double, y:Double) {
        let mPerDegLat =  111132.954 - 559.822 * cos( 2 * latitude ) + 1.175 * cos( 4 * latitude)
        let mPerDegLong = 111132.954 * cos ( latitude )
        return (x: longitude * mPerDegLong, y: latitude * mPerDegLat)
    }
    
    // Convert to meters. Add Math.
    func addMeters(x: Double, y: Double) -> LocationObj{
        let mPerDegLat =  111132.954 - 559.822 * cos( 2 * latitude ) + 1.175 * cos( 4 * latitude)
        let mPerDegLong = 111132.954 * cos ( latitude )
        return LocationObj(latitude: self.latitude + y / mPerDegLat, longitude: self.longitude + x / mPerDegLong, time: self.time)
    }
    
    // Determine Coordinates
    func asXY() -> XYPoint{
        //Cartesion coordinates takes the form if (Longitude, Latitude) or Vertical, Horizontal
        return (x: self.longitude, y:self.latitude)
    }
}

// Array for Location Services
extension Array {
    mutating func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
    }
}


// MARK: Main Class

class LocationServicesHandler : NSObject {
    struct LOCATION_SETTINGS {
        static let UPDATE_DISTANCE = 10.0
    }
    
    override init(){
        super.init()
    }
    static let min_radius = 250.0
    

/* This function will generate a polygon (list of vertices) which enclose the given locations if
   their locations are close enough 
*/
    
    static func generateFence(forUser: String, forLocations: [LocationObj], mapView: GMSMapView)-> [GeoFence]{

        
        /*for location in newList{
            let newCircle = GMSCircle(position: location.asCoordinate(), radius: min_radius)
                newCircle.strokeColor = .red
                newCircle.map = mapView
        }*/
        
        //Separate clusters

        
//        let firstReduce = LocationServicesHandler.simplifyLocationList(locationList: forLocations)
//        let groupedLocations = LocationServicesHandler.reduceLocationListOverlap(locationList: firstReduce)
        
        let clusterResult = cluster(locationList: forLocations)
        
        var groupedLocationsC = [[LocationObj]]()
        for clusterConst in clusterResult{
            var cluster = clusterConst
            if cluster.count == 0{
                continue
            }
            cluster.sort(by: {
                $0.time < $1.time
            })
            let firstReduce = LocationServicesHandler.simplifyLocationList(locationList: cluster)
            let grouped = LocationServicesHandler.reduceLocationListOverlap(locationList: firstReduce)
            if grouped.count < 2{
                continue
            }
            groupedLocationsC += [grouped] //[]
        }
        /*
        for each in groupedLocationsC {
            print("Cluster")
            print(each)
            var opacity = 0.1
            for each2 in each {
                let newCircle = GMSCircle(position: each2.asCoordinate(), radius: min_radius * (each2.weight ?? 1.0))
                newCircle.strokeColor = .red
                newCircle.fillColor = UIColor(red: 1, green: 1, blue: CGFloat(opacity), alpha: CGFloat(opacity))
                newCircle.map = mapView
                opacity += 0.1
            }
        }*/
        /*
        for location in groupedLocations{
            let newCircle = GMSCircle(position: location.asCoordinate(), radius: min_radius * (location.weight ?? 1.0))
            newCircle.strokeColor = .red
            newCircle.map = mapView
        }*/
        
        //Separate clusters here. Then plug each cluster into the algorithm separately.
        
        var rectPoints = [[XYPoint]]()
        for cluster in groupedLocationsC {
            var clusterRectPoints = [XYPoint]()
            for location in cluster{
                let radius = min_radius * (location.weight ?? 1.0)
                clusterRectPoints.append(location.addMeters(x: radius, y: radius).asXY())
                clusterRectPoints.append(location.addMeters(x: radius, y: -radius).asXY())
                clusterRectPoints.append(location.addMeters(x: -radius, y: -radius).asXY())
                clusterRectPoints.append(location.addMeters(x: -radius, y: radius).asXY())

            }
            rectPoints += [clusterRectPoints]
            
        }
        
        var pointsOutsideHull = [XYPoint]()
        var retVal = [GeoFence]()
        
        for cluster in rectPoints{
            let hull = generateConcaveHull(locationList: cluster, otherPoints: &pointsOutsideHull)
            retVal.append((inclusion: hull, exclusion: emptyPoints))
        }

        //Also generate inner fence.
        
        
        //print(result)
        for result in retVal{
            let FinalPolygon = createPolygonFromPoints(pointList: result.inclusion)
            
            let polygon = GMSPolygon(path: FinalPolygon)
                polygon.fillColor = UIColor(red: 0.8, green: 0.5, blue: 0, alpha: 0.3);
                polygon.strokeColor = .black
                polygon.strokeWidth = 2
                polygon.map = mapView
        }
        return retVal
    }
    
    // Detect holes in Information collected on clusters.
    static func detectHolesInCluster(){
        
    }
    
    // Determine cluserts to build safe areas.
    static private func cluster(locationList: [LocationObj]) -> [[LocationObj]]{
        //Based on OPTICS clustering algorithm
        var sortedList = locationList
        var currentPoints = [LocationObj]()
        let max_distance = 2 * 0.01 * 0.01
        let k = 5
        var clusters = [[LocationObj]]()
        clusters += [[LocationObj]()]
        var clusters_counted = 0
        
        while (sortedList.count > 0){
            currentPoints.append(sortedList[0])
            clusters += [[LocationObj]()]
            let core = sortedList[0]
            sortedList.remove(at: 0)

            while currentPoints.count > 0{
                let point = currentPoints[0]; currentPoints.remove(at: 0)
                sortByDistance(firstPoint: point, otherPoints: &sortedList)
                var indicesToRemove = [Int]()
                for index in 0..<min(k,sortedList.count){
                    if min(distance2(p1: core.asXY(), p2: sortedList[index].asXY()),
                           distance2(p1: point.asXY(), p2: sortedList[index].asXY())) < max_distance {
                        
                        clusters[clusters_counted].append(sortedList[index])
                        currentPoints.append(sortedList[index])
                        indicesToRemove.append(index)
                    
                    }
                }
                sortedList.remove(at: indicesToRemove)
            }
            clusters_counted += 1
        }
        
        return clusters
    }
    
    // Create safe areas using Polygons
    static private func createPolygonFromPoints(pointList: [XYPoint]) -> GMSMutablePath {
        let returnPoly = GMSMutablePath()
        for index in 0..<pointList.count-1{
            let point = pointList[index]
            let newLocation = CLLocationCoordinate2D(latitude: point.y, longitude: point.x)
            returnPoly.add(newLocation)
        }
        return returnPoly
    }
    
    // Convert to points for easier mathematical solution.
    static func convertToPointList(locationList: [LocationObj]) -> [(x:Double,y:Double)]{

        var newPoints = [(x:Double, y:Double)]()
        for location in locationList{
            newPoints.append(location.getInMeters())
        }
        return newPoints
    }
    
    // Reduce repeated points.
    static func reduceLocationListOverlap(locationList: [LocationObj]) -> [LocationObj]{
        var newList = locationList
        newList.sort { (lhs: LocationObj, rhs: LocationObj) -> Bool in
            return lhs.latitude < rhs.latitude || (lhs.latitude == rhs.latitude && lhs.longitude < rhs.longitude)
         }
        return simplifyLocationList(locationList: newList)
    }
    

/* Reduces the locationList by proximity of each point. 
   Overlapping points will reduce the radius/increase the accuracy of the location.
   Relatively close points will merge and average, given a slightly larger area.

*/

    // Simplify location list to do the math better.
    static private func simplifyLocationList(locationList: [LocationObj]) -> [LocationObj]{
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

/* To be used with the output of generateFence() */

    static func isPointInsideFence(currentLocation: CLLocationCoordinate2D, fence: [XYPoint]) -> Bool{
        return pointInPolygon(pointCheck: (x: currentLocation.longitude, y: currentLocation.latitude), pointList: fence)
    }
    
    static func isPointInsideFence(currentLocation: CLLocationCoordinate2D, multiFence: [GeoFence]) -> Bool{
        for fence in multiFence{
            let inclusionZone = pointInPolygon(pointCheck: (x: currentLocation.longitude, y: currentLocation.latitude), pointList: fence.inclusion)
            let exclusionZone = pointInPolygon(pointCheck: (x: currentLocation.longitude, y: currentLocation.latitude), pointList: fence.exclusion)
            let currentResult = inclusionZone && !exclusionZone
            if currentResult{
                return true
            }
        }
        
        return false
    }
    
/*  Implemented algorithm to generate the concave hull of the locations visited
     
     http://repositorium.sdum.uminho.pt/bitstream/1822/6429/1/ConcaveHull_ACM_MYS.pdf
*/

    // Create concave hull.
    static private func generateConcaveHull (locationList: [XYPoint], otherPoints: inout [XYPoint], searchComplexity: Int = 8) -> [XYPoint]{
        var workingSet = locationList
        var hull = [XYPoint]()
        workingSet.sort { (lhs: XYPoint, rhs: XYPoint) -> Bool in
            return (lhs.y < rhs.y)
        }
        
        let firstPoint = workingSet[0]
        workingSet.remove(at: 0)
        hull.append(firstPoint)
        let k = searchComplexity
        var currentPoint = firstPoint
        var step = 1
        var previousAngle = 0.0
        while (currentPoint != firstPoint || step == 1){
            if step == 3{
                workingSet.insert(firstPoint, at: 0)
            }
            sortByDistance(firstPoint: currentPoint, otherPoints: &workingSet)
            var test2 = workingSet[0..<min(k, workingSet.count)]
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
                //print(atan2(point.y - currentPoint.y, point.x - currentPoint.x) - previousAngle)
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
        }
        print(workingSet.count)
        for point in workingSet {
            if !pointInPolygon(pointCheck: point, pointList: hull) && !pointNearPolygon(pointCheck: point, pointList: hull){
                
                otherPoints.append(point)
            }
        }
        return hull
    }

    // Sort the data by distance
    static func sortByDistance(firstPoint: XYPoint, otherPoints: inout [XYPoint]){
        otherPoints.sort(by: {distance2(p1: firstPoint, p2: $0) < distance2(p1: firstPoint, p2: $1)})
    }
    
    // Sort data by distance
    static func sortByDistance(firstPoint: LocationObj, otherPoints: inout [LocationObj]){
        otherPoints.sort(by: {distance2(p1: firstPoint.asXY(), p2: $0.asXY()) < distance2(p1: firstPoint.asXY(), p2: $1.asXY())})
    }
    
    // Math function to determine distance
    static func distance(p1: XYPoint, p2: XYPoint) -> Double{
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return (sqrt(x*x + y*y))
    }


    // Math function to determine distance
    static func distance2(p1: XYPoint, p2: XYPoint) -> Double{
    //Does not take the square root. Speeds up calculation
        let x = p1.x - p2.x
        let y = p1.y - p2.y
        return x*x+y*y
    }

    //Sends the location data to firebase

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
    // Send updates on location to database
    static func newestLocationUpdates(forID: String, nextLocation: ((LocationObj) -> Void)?) -> DatabaseHandle{
        let userID = forID //Auth.auth().currentUser?.uid
        
        let childRef = FirebaseDatabase.sharedInstance.locationRef.child(userID)
        let queryRef = childRef.queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot: DataSnapshot) in
                let locationInfo = snapshot.value as! [String:Any]
                let retVal = LocationObj(latitude: locationInfo["latitude"] as! Double,
                                         longitude: locationInfo["longitude"] as! Double,
                                         time: locationInfo["time"] as! Double )
                nextLocation?(retVal)
        })
        return queryRef
    }
    // Get updates on location from database
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
    
    // Extract data on location from database. Data includes latitude, longtitude and time.
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
    
    // Determine time
    static func getNewEndingPoint() -> Double{
        return NSDate().timeIntervalSince1970.rounded() + 1
    }


/* Uses vectors to determine if the point given is inside the polygon defined by the list */
    static func pointNearPolygon(pointCheck: XYPoint, pointList: [XYPoint])-> Bool{
        var copy = pointList
        sortByDistance(firstPoint: pointCheck, otherPoints: &copy)
        return distance2(p1: pointCheck, p2: copy[0]) < 2 * (0.01*0.01)
    }
    
    // Mathematical function to determine if location in safe area.
    static func pointInPolygon(pointCheck: XYPoint, pointList: [XYPoint])-> Bool{
       
        if pointList.count == 0 {
            return false
        }
        
        var count = 0
        
        for index in 0..<pointList.count-1 {
            
            if rayIntersectLine(rayOrigin: pointCheck, rayDirection: (x: 1, y:0), p1: pointList[index], p2: pointList[index+1]) != nil{
                count += 1
            }
        }
        //If there are an odd number of intersections that means the point is inside the polygon
        return count % 2 == 1
        
    }

/* Draws a vector out from the origin. The result is the intersection as a parameter t 
   for origin + t*ray
*/ 
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

    // Determine if multiple safe areas's edges overlap
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

    // Determine if multiple safe areas's edges overlap
    static func lineCrossesLine(firstLine: [XYPoint], secondLine: [XYPoint])-> Bool{
        
/*
         a# = Difference in y for line#
         b# = Difference in x for line#
         c# = Cross product of the two points of line# as if they were vectors
         
         d# is the line in the form A*x+ B*y + C = 0
         However by plugging in values for x and y from the second line (v2),
         we can determine which side of the first line the second line is on.
         If the signs are the same, then the 2 points of the second line are on the same side
         Therefore they do not cross the first line
         
         Repeat using the points from the second line to determine A B and C.
         
 */
        
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
