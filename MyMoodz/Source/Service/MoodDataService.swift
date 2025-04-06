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
    
    func fetchAllMoods() -> [MoodEntry] {
        let request: NSFetchRequest<MoodEntry> = MoodEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            Log.d("❌ Failed to fetch moods: \(error)")
            return []
        }
    }

    func deleteMood(_ mood: MoodEntry) {
        context.delete(mood)
        do {
            try context.save()
        } catch {
            Log.d("Failed to delete mood: \(error)")
        }
    }

    func updateMood(_ entry: MoodEntry, newNote: String?, newEmoji: String?) {
        entry.note = newNote
        entry.emoji = newEmoji
        entry.timestamp = Date()
        do {
            try context.save()
            context.refresh(entry, mergeChanges: true)
            Log.d("✅ Mood updated")
        } catch {
            Log.d("Failed to update mood: \(error)")
        }
    }
    
    func fetchEntry(by id: UUID) -> MoodEntry? {
        let request: NSFetchRequest<MoodEntry> = MoodEntry.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first
    }
}
