//
//  MyMoodzApp.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

@main
struct MyMoodzApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

