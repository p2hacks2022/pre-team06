//
//  ContentView.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State var selectedTab = 0
    
    var body: some View {
        if (locationManager.whichView == .search) {
            SearchView()
        } else {
            TabView(selection: $selectedTab) {
                DirectionView()
                    .tabItem {
                        Image(selectedTab == 0 ? "DirectionViewTabSelectedIcon" : "DirectionViewTabUnselectedIcon")
                        Text("Direction")
                    }
                    .tag(0)
                
                AdventureView()
                    .tabItem {
                        Image(selectedTab == 1 ? "AdventureViewTabSelectedIcon" : "AdventureViewTabUnselectedIcon")
                        Text("Adventure")
                    }
                    .tag(1)

                CheatingView()
                    .tabItem {
                        Image(selectedTab == 2 ? "CheatingViewTabSelectedIcon" : "CheatingViewTabUnselectedIcon")
                        Text("Cheat")
                    }
                    .tag(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocationManager())
    }
}
