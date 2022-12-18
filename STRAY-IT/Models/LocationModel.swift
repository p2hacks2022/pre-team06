//
//  MapModel.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/11.
//

import Foundation
import MapKit

enum Views {
    case search
    case direction
    case adventure
    case cheating
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let localSearchManagerByQuery = LocalSearchManager.SearchByQuery()
    let localSearchManagerByLocation = LocalSearchManager.SearchByLocation()
    var adventureMapViewManager: MapViewManager!
    var cheatingMapViewManager: MapViewManager!
    
    @Published var whichView: Views
    @Published var adventureCurrentLocationMark: IdentifiablePlace!
    @Published var cheatingCurrentLocationMark: IdentifiablePlace!
    @Published var adventureDirectionRequest: MKDirections.Request
    @Published var cheatingDirectionRequest: MKDirections.Request
    @Published var isDiscovering: Bool
    @Published var region: MKCoordinateRegion
    @Published var start_and_goal: [IdentifiablePlace]
    @Published var headingDirection: CGFloat
    @Published var destinationDirection: CGFloat
    @Published var distance: CGFloat
    
    override init() {
        whichView = .search
        isDiscovering = false
        adventureDirectionRequest = MKDirections.Request()
        cheatingDirectionRequest = MKDirections.Request()
        region = MKCoordinateRegion()
        start_and_goal = [IdentifiablePlace(latitude: 0, longitude: 0, title: nil, subtitle: nil), IdentifiablePlace(latitude: 0, longitude: 0, title: nil, subtitle: nil)]
        headingDirection = 0
        destinationDirection = 0
        distance = 0
        
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1.0
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                latitudinalMeters: 1000.0,
                longitudinalMeters: 1000.0
            )
        }
        
        if (isDiscovering) {
            localSearchManagerByLocation.searchNearHear(center: region.center, radius: region.span.latitudeDelta)
            localSearchManagerByLocation.setDirection(currentCoordinate: region.center, headingDirection: headingDirection)
            getDistanceFromHereToGoal()
            getDestinationDirection()
        }
        
        updateCurrentLocationOnAdventureMapView()
        updateCurrentLocationOnCheatingMapView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        headingDirection = heading.magneticHeading
        
        if (isDiscovering) {
            getDistanceFromHereToGoal()
            getDestinationDirection()
            localSearchManagerByLocation.setDirection(currentCoordinate: region.center, headingDirection: headingDirection)
        }
    }
}

extension LocationManager {
    
    public func setDestination(_ destination: IdentifiablePlace) {
        clearMapViewInstances()
        start_and_goal = [IdentifiablePlace(coordinate: region.center, title: nil, subtitle: nil), destination]
        
        getDistanceFromHereToGoal()
        getDestinationDirection()
    }
    
    private func getDistanceFromHereToGoal() {
        if (start_and_goal[0] != start_and_goal[1]) {
            let currentCoordinate = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            let goalCoordinate = CLLocation(latitude: start_and_goal[1].coordinate.latitude, longitude: start_and_goal[1].coordinate.longitude)
            distance = LocationCalculator().getDistance(currentCoordinate, goalCoordinate)
        }
    }
    
    private func getDestinationDirection() {
        if (start_and_goal[0] != start_and_goal[1]) {
            destinationDirection = LocationCalculator().getDirectionDelta(region.center, start_and_goal[1].coordinate, headingDirection: headingDirection)
        }
    }
}

extension LocationManager {
    
    func clearMapViewInstances() {
        adventureMapViewManager = nil
        cheatingMapViewManager = nil
        adventureCurrentLocationMark = nil
        cheatingCurrentLocationMark = nil
    }
    
    func initAdventureMapView() {
        if (adventureMapViewManager == nil) {
            adventureMapViewManager = MapViewManager()
            
            adventureMapViewManager.mapViewObject.addAnnotation(start_and_goal[0])
            adventureMapViewManager.mapViewObject.addAnnotation(start_and_goal[1])
            
            adventureDirectionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: start_and_goal[0].coordinate))
            adventureDirectionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: start_and_goal[1].coordinate))
            adventureDirectionRequest.transportType = MKDirectionsTransportType.walking
            
            let directions = MKDirections(request: adventureDirectionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                let route = directionResponse.routes[0]
                
                if (self.whichView == .cheating) {
                    self.adventureMapViewManager.mapViewObject.addOverlay(route.polyline, level: .aboveRoads)
                }
                
                let rect = route.polyline.boundingMapRect
                var rectRegion = MKCoordinateRegion(rect)
                rectRegion.span.latitudeDelta = rectRegion.span.latitudeDelta * 1.4
                rectRegion.span.longitudeDelta = rectRegion.span.longitudeDelta * 1.4
                self.adventureMapViewManager.mapViewObject.setRegion(rectRegion, animated: true)
            }
        }
    }
    
    func initCheatingMapView() {
        if (cheatingMapViewManager == nil) {
            cheatingMapViewManager = MapViewManager()
            
            cheatingMapViewManager.mapViewObject.addAnnotation(start_and_goal[0])
            cheatingMapViewManager.mapViewObject.addAnnotation(start_and_goal[1])
            
            cheatingDirectionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: start_and_goal[0].coordinate))
            cheatingDirectionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: start_and_goal[1].coordinate))
            cheatingDirectionRequest.transportType = MKDirectionsTransportType.walking
            
            let directions = MKDirections(request: cheatingDirectionRequest)
            directions.calculate { (response, error) in
                guard let directionResponse = response else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }
                
                let route = directionResponse.routes[0]
                
                self.cheatingMapViewManager.mapViewObject.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                var rectRegion = MKCoordinateRegion(rect)
                rectRegion.span.latitudeDelta = rectRegion.span.latitudeDelta * 1.4
                rectRegion.span.longitudeDelta = rectRegion.span.longitudeDelta * 1.4
                self.cheatingMapViewManager.mapViewObject.setRegion(rectRegion, animated: true)
            }
        }
    }
    
    func updateCurrentLocationOnAdventureMapView() {
        if (adventureMapViewManager != nil && !LocationCalculator().isSameLocation(region.center, start_and_goal[0].coordinate)) {
            if (adventureCurrentLocationMark == nil) {
                adventureCurrentLocationMark = IdentifiablePlace(coordinate: region.center, title: nil, subtitle: "Current Location")
                adventureMapViewManager.headingDirection = headingDirection
                adventureMapViewManager.mapViewObject.addAnnotation(adventureCurrentLocationMark)
            } else {
                var lineLocation: [CLLocationCoordinate2D] = [adventureCurrentLocationMark.coordinate, region.center]
                let line = MKPolyline(coordinates: &lineLocation, count: 2)
                adventureMapViewManager.mapViewObject.addOverlay(line, level: .aboveRoads)
                adventureMapViewManager.mapViewObject.removeAnnotation(adventureCurrentLocationMark)
                adventureCurrentLocationMark = IdentifiablePlace(coordinate: region.center, title: nil, subtitle: "Current Location")
                adventureMapViewManager.mapViewObject.addAnnotation(adventureCurrentLocationMark)
                adventureMapViewManager.headingDirection = headingDirection
            }
        }
    }
    
    func updateCurrentLocationOnCheatingMapView() {
        if (cheatingMapViewManager != nil && !LocationCalculator().isSameLocation(region.center, start_and_goal[0].coordinate)) {
            if (cheatingCurrentLocationMark == nil) {
                cheatingCurrentLocationMark = IdentifiablePlace(coordinate: region.center, title: nil, subtitle: "Current Location")
                cheatingMapViewManager.headingDirection = headingDirection
                cheatingMapViewManager.mapViewObject.addAnnotation(cheatingCurrentLocationMark)
            } else {
                cheatingMapViewManager.mapViewObject.removeAnnotation(cheatingCurrentLocationMark)
                cheatingCurrentLocationMark = IdentifiablePlace(coordinate: region.center, title: nil, subtitle: "Current Location")
                cheatingMapViewManager.mapViewObject.addAnnotation(cheatingCurrentLocationMark)
                cheatingMapViewManager.headingDirection = headingDirection
            }
        }
    }
}
