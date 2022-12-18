//
//  AdventureView.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/17.
//

import SwiftUI

struct AdventureView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        AdventureMapView()
            .background(Color("Background"))
            .edgesIgnoringSafeArea([.top, .horizontal])
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    locationManager.whichView = .adventure
                }
            }
    }
}

struct AdventureView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureView()
            .environmentObject(LocationManager())
    }
}
