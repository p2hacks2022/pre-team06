//
//  SearchModel.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import Foundation
import MapKit

class LocalSearchManager {
    
    class SearchByQuery {
        private var request: MKLocalSearch.Request
        private var search: MKLocalSearch
        public var results: [MKMapItem] = []
        
        init() {
            request = MKLocalSearch.Request()
            request.resultTypes = [.address, .pointOfInterest]
            search = MKLocalSearch(request: request)
        }
        
        public func setRegion(_ region: MKCoordinateRegion) {
            request.region = region
        }
        
        public func updateQueryText(_ text: String) {
            request.naturalLanguageQuery = text
            
            searchQuery()
        }
        
        public func executeQuery() {
            search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                
                self.results = response.mapItems
            }
        }
        
        public func searchQuery() {
            if (request.naturalLanguageQuery != "") {
                executeQuery()
            }
        }
        
        public func isSearching() -> Bool {
            return search.isSearching
        }
    }
    
    class SearchByLocation {
        private var request: MKLocalPointsOfInterestRequest
        private var search: MKLocalSearch
        private var results: [MKMapItem]
        public var landmarks: [Landmark]
        private var radius: CLLocationDistance
        private var timestamp: Date
        
        init() {
            request = MKLocalPointsOfInterestRequest(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 1)
            search = MKLocalSearch(request: request)
            results = []
            landmarks = []
            radius = 50.0
            timestamp = .now
        }
        
        public func makeRequest(center: CLLocationCoordinate2D, radius: CLLocationDistance) {
            request = MKLocalPointsOfInterestRequest(center: center, radius: radius)
        }
        
        public func searchNearHear(center: CLLocationCoordinate2D, radius: CLLocationDistance) {
            if (Date.now.timeIntervalSince(timestamp) > 10) {
                makeRequest(center: center, radius: radius)
                search = MKLocalSearch(request: request)
                search.start { response, _ in
                    guard let response = response else {
                        return
                    }
                    
                    self.results = response.mapItems
                }
                
                timestamp = Date.now
            }
            
            makeLandmarkList()
        }
        
        private func makeLandmarkList() {
            for item in results {
                let title = item.name
                let coordinate = item.placemark.coordinate
                let category = item.pointOfInterestCategory
                
                var isMultiple = false
                
                for landmark in landmarks {
                    if (landmark.coordinate.latitude == coordinate.latitude && landmark.coordinate.longitude == coordinate.longitude) {
                        isMultiple = true
                    }
                    if (LocationCalculator().getDistance(CLLocation(latitude: landmark.coordinate.latitude, longitude: landmark.coordinate.longitude), CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) > radius) {
                        landmarks.remove(at: landmarks.firstIndex(where: {$0.id == landmark.id})!)
                    }
                }
                if (!isMultiple) {
                    landmarks.append(Landmark(coordinate: coordinate, title: title, subtitle: nil, pointOfInterestCategory: category))
                }
            }
        }
        
        public func setDirection(currentCoordinate: CLLocationCoordinate2D, headingDirection: CGFloat) {
            landmarks.forEach { item in
                item.setDirection(LocationCalculator().getDirectionDelta(currentCoordinate, item.coordinate, headingDirection: headingDirection))
            }
        }
    }
}
