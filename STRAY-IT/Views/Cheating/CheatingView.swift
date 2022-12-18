//
//  CheatingView.swift
//  STRAY-IT
//
//  Created by inoue mei on 2022/12/17.
//

import SwiftUI

struct CheatingView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        CheatingMapView()
            .background(Color("Background"))
            .edgesIgnoringSafeArea([.top, .horizontal])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    locationManager.whichView = .cheating
                }
            }
    }
}

struct CheatingView_Previews: PreviewProvider {
    static var previews: some View {
        CheatingView()
            .environmentObject(LocationManager())
    }
}
