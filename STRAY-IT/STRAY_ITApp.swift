//
//  STRAY_ITApp.swift
//  STRAY-IT
//
//  Created by Kanta Oikawa on 2022/12/11.
//

import SwiftUI

@main
struct STRAY_ITApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationManager())
        }
    }
}
