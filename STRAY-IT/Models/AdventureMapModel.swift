//
//  AdventureMapModel.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import Foundation
import MapKit
import SwiftUI

struct AdventureMapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Self.Context) -> UIViewType {
        locationManager.initAdventureMapView()
        
        return locationManager.adventureMapViewManager.mapViewObject
    }
    
    func updateUIView(_ uiView: MKMapView, context: Self.Context) {
        uiView.delegate = locationManager.adventureMapViewManager
    }
}

struct AdventureMapView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureMapView()
            .environmentObject(LocationManager())
    }
}
