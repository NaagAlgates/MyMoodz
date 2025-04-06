//
//  MyMoodzApp.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

@main
struct MyMoodzApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
    
    init(){
        for family in UIFont.familyNames {
            print("🔤 Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   - \(name)")
            }
        }
    }

}

