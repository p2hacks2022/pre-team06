//
//  LandmarksView.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/15.
//

import SwiftUI

struct Landmarks: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                ForEach(locationManager.localSearchManagerByLocation.landmarks) { item in
                    if (item.getPointOfInterestCategoryImageName() != nil) {
                        Image(item.getPointOfInterestCategoryImageName()!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .position(x: geometry.size.width / 2 + LocationCalculator().getPosition(geometry.size.width * 0.8 / 2, item.direction)[0], y: geometry.size.height / 2 + LocationCalculator().getPosition(geometry.size.width * 0.8 / 2, item.direction)[1])
                    }
                }
            }
        }
    }
}

struct LandmarksView_Previews: PreviewProvider {
    static var previews: some View {
        Landmarks()
            .environmentObject(LocationManager())
    }
}
