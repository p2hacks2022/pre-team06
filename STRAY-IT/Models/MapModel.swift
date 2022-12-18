//
//  MapModel.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import Foundation
import MapKit
import SwiftUI

class MapViewManager: NSObject, MKMapViewDelegate{
    var mapViewObject = MKMapView()
    var headingDirection: CGFloat!
    
    override init() {
        super.init()
        mapViewObject.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(named: "RouteColor")
        renderer.lineWidth = 8.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            
            if (annotationView.annotation?.subtitle == "Current Location") {
                annotationView.markerTintColor = UIColor(named: "AccentColor")
                annotationView.glyphImage = UIImage(systemName: "location.fill")
                
                return annotationView
            }
            
            annotationView.markerTintColor = UIColor(named: "RouteColor")
            annotationView.glyphImage = UIImage(named: "Marker")
            
            return annotationView
        }
    }
}
