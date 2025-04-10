//
//  PersistenceController.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoodModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("💥 Core Data failed to load: \(error)")
            }
        }
    }
}
