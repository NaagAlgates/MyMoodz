//
//  MoodDataService.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import Foundation
import CoreData

final class MoodDataService {
    static let shared = MoodDataService()

    private let context: NSManagedObjectContext

    private init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveMood(emoji: String, note: String?) {
        let mood = MoodEntry(context: context)
        mood.id = UUID()
        mood.emoji = emoji
        mood.note = note
        mood.timestamp = Date()

        do {
            try context.save()
            Log.d("✅ Mood saved successfully")
        } catch {
            Log.d("❌ Failed to save mood: \(error)")
        }
    }

    func fetchLatestMood() -> MoodEntry? {
        let request: NSFetchRequest<MoodEntry> = MoodEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            Log.d("❌ Failed to fetch latest mood: \(error)")
            return nil
        }
    }
    // We'll add fetch, update, delete next
}
