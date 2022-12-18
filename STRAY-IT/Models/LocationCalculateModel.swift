//
//  LocationCalculateModel.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import Foundation
import CoreLocation

class LocationCalculator {
    
    public func getDistance(_ originalCoordinate: CLLocation, _ targetCoordinate: CLLocation) -> CGFloat {
        return originalCoordinate.distance(from: targetCoordinate)
    }
    
    public func getDirectionDelta(_ originalCoordinate: CLLocationCoordinate2D, _ targetCoordinate: CLLocationCoordinate2D, headingDirection: CGFloat) -> CGFloat {
        var direction: CGFloat
        
        let originalLatitude = toRadian(originalCoordinate.latitude)
        let originalLongitude = toRadian(originalCoordinate.longitude)
        let targetLatitude = toRadian(targetCoordinate.latitude)
        let targetLongitude = toRadian(targetCoordinate.longitude)
        
        let longitudeDelta = targetLongitude - originalLongitude
        let y = sin(longitudeDelta)
        let x = cos(originalLatitude) * tan(targetLatitude) - sin(originalLatitude) * cos(longitudeDelta)
        let p = atan2(y, x) * 180 / CGFloat.pi
        
        if p < 0 {
            direction = 360 + atan2(y, x) * 180 / CGFloat.pi
        } else {
            direction = atan2(y, x) * 180 / CGFloat.pi
        }
        
        direction -= headingDirection
        
        return direction
    }
    
    public func getPosition(_ radius: CGFloat, _ degrees: CGFloat) -> [CGFloat] {
        let theta = toRadian(degrees)
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        
        return [x, y]
    }
    
    private func toRadian(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat.pi / 180
    }
    
    public func isSameLocation(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Bool {
        if (coordinate1.latitude == coordinate2.longitude && coordinate1.longitude == coordinate2.latitude) {
            return true
        }
        return false
    }
}
