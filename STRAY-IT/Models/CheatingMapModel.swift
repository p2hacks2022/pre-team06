//
//  CheatingMapModel.swift
//  STRAY-IT
//
//  Created by inoue mei on 2022/12/17.
//

import Foundation
import MapKit
import SwiftUI

struct CheatingMapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Self.Context) -> UIViewType {
        locationManager.initCheatingMapView()
        
        return locationManager.cheatingMapViewManager.mapViewObject
    }
    
    func updateUIView(_ uiView: MKMapView, context: Self.Context) {
        uiView.delegate = locationManager.cheatingMapViewManager
    }
}

struct CheatingMapView_Previews: PreviewProvider {
    static var previews: some View {
        CheatingMapView()
            .environmentObject(LocationManager())
    }
}
