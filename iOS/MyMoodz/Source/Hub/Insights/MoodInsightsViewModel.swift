//
//  MoodInsightsViewModel.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 13/4/2025.
//

import Foundation
import CoreData

class MoodInsightsViewModel: ObservableObject {
    @Published var moodCounts: [(emoji: String, count: Int)] = []
    @Published var totalEntries: Int = 0
    @Published var mostFrequentMood: String = "🙂"
    @Published var longestStreak: Int = 0

    private let context = PersistenceController.shared.container.viewContext

    func fetchMoodData() {
        let request: NSFetchRequest<MoodEntry> = MoodEntry.fetchRequest()

        do {
            let moods = try context.fetch(request)
            totalEntries = moods.count

            let grouped = Dictionary(grouping: moods, by: { $0.emoji ?? "❓" })
            moodCounts = grouped.map { (emoji: $0.key, count: $0.value.count) }
                .sorted { $0.count > $1.count }

            mostFrequentMood = moodCounts.first?.emoji ?? "🙂"
            longestStreak = calculateLongestStreak(from: moods)
        } catch {
            print("Failed to fetch moods: \(error.localizedDescription)")
        }
    }

    private func calculateLongestStreak(from moods: [MoodEntry]) -> Int {
        let dates = moods.compactMap { $0.timestamp?.stripTime() }.sorted()
        guard !dates.isEmpty else { return 0 }

        var longest = 1
        var current = 1

        for i in 1..<dates.count {
            if Calendar.current.isDate(dates[i - 1].addingDays(1), inSameDayAs: dates[i]) {
                current += 1
                longest = max(longest, current)
            } else if !Calendar.current.isDate(dates[i - 1], inSameDayAs: dates[i]) {
                current = 1
            }
        }

        return longest
    }
}
