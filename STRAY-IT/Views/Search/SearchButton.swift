//
//  SearchButton.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/13.
//

import SwiftUI

struct SearchButton: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    locationManager.whichView = .search
                }) {
                    Image("SearchSmall")
                        .padding(16.0)
                }
                .background(Color("AccentColor"))
                .cornerRadius(128.0)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.top, 64.0)
        .padding(.leading, 32.0)
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton()
            .environmentObject(LocationManager())
    }
}
