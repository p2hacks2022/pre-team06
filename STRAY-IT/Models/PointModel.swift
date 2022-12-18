//
//  PointStructure.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import Foundation
import MapKit

class IdentifiablePlace: NSObject, MKAnnotation, Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(id: UUID = UUID(), latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        self.id = id
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
    
    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class Landmark: IdentifiablePlace {
    var pointOfInterestCategory: MKPointOfInterestCategory?
    var direction: CGFloat
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, pointOfInterestCategory: MKPointOfInterestCategory?) {
        self.pointOfInterestCategory = pointOfInterestCategory
        self.direction = 0
        
        super.init(coordinate: coordinate, title: title, subtitle: subtitle)
    }
    
    func setDirection(_ newDirection: CGFloat) {
        direction = newDirection
    }
    
    func getPointOfInterestCategoryImageName() -> String? {
        if (pointOfInterestCategory != nil) {
            switch (pointOfInterestCategory!) {
            case .atm:
                return "Atm"
            case .bakery:
                return "Bakery"
            case .bank:
                return "Bank"
            case .cafe:
                return "Cafe"
            case .carRental:
                return "CarRental"
            case .fireStation:
                return "FireStation"
            case .fitnessCenter:
                return "FitnessCenter"
            case .foodMarket:
                return "FoodMarket"
            case .gasStation:
                return "GasStation"
            case .hospital:
                return "Hospital"
            case .hotel:
                return "Hotel"
            case .laundry:
                return "Laundry"
            case .library:
                return "Library"
            case .movieTheater:
                return "MovieTheater"
            case .museum:
                return "Museum"
            case .park:
                return "Park"
            case .parking:
                return "Parking"
            case .pharmacy:
                return "Pharmacy"
            case .police:
                return "Police"
            case .postOffice:
                return "PostOffice"
            case .publicTransport:
                return "PublicTransport"
            case .restaurant:
                return "Restaurant"
            case .restroom:
                return "Restroom"
            case .school:
                return "School"
            case .store:
                return "Store"
            case .university:
                return "University"
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
