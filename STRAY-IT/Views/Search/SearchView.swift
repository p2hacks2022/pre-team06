//
//  SearchView.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/13.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var queryText: String = ""
    @FocusState private var searchBarIsFocused: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("AccentColor"))
                HStack {
                    Image("SearchSmall")
                    TextField("", text: $queryText)
                        .accentColor(Color("Background"))
                        .focused($searchBarIsFocused)
                }
                .foregroundColor(Color("Background"))
                .padding(.leading, 12)
            }
            .frame(height: 40)
            .cornerRadius(24)
            .padding()
            
            ScrollView {
                if (locationManager.localSearchManagerByQuery.isSearching()) {
                    ProgressView()
                } else {
                    ForEach(locationManager.localSearchManagerByQuery.results, id: \.self) { result in
                        Button (action: {
                            searchBarIsFocused = false
                            
                            let coordinate = result.placemark.coordinate
                            let title = result.name
                            locationManager.setDestination(IdentifiablePlace(latitude: coordinate.latitude, longitude: coordinate.longitude, title: title, subtitle: nil))
                            
                            locationManager.whichView = .direction
                        }) {
                            HStack {
                                VStack {
                                    HStack {
                                        Text(result.name ?? "No Name")
                                        Spacer()
                                    }
                                    .padding(.vertical, 2.0)
                                }
                                .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .foregroundColor(Color("AccentColor"))
                        }
                        .padding(.top, 8.0)
                        .padding(.bottom, 2.0)
                        .padding(.horizontal, 32.0)
                        
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                locationManager.isDiscovering = false
                searchBarIsFocused = true
            }
        }
        .onChange(of: queryText, perform: { newValue in
            locationManager.localSearchManagerByQuery.setRegion(locationManager.region)
            locationManager.localSearchManagerByQuery.updateQueryText(newValue)
        })
        .onSubmit {
            searchBarIsFocused = false
        }
        .background(Color("Background"))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(LocationManager())
    }
}
