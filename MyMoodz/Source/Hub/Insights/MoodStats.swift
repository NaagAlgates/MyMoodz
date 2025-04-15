//
//  MoodStats.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 13/4/2025.
//

import Foundation

struct MoodStats {
    
    // A simple model representing the count of a specific mood.
    struct MoodCount: Identifiable {
        let id = UUID()
        let emoji: String
        let count: Int
    }
    
    // The raw mood entries used in calculations.
    private let moods: [MoodEntry]
    
    // Statistics computed from the mood entries.
    var moodCounts: [MoodCount]
    var mostFrequentMood: MoodCount?
    var totalEntries: Int
    var longestStreak: Int
    
    // Initializes by computing statistics from the given array of MoodEntry.
    init(moods: [MoodEntry]) {
        self.moods = moods
        
        // Group mood entries by emoji (using a fallback "❓" if missing).
        let grouped = Dictionary(grouping: moods, by: { $0.emoji ?? "❓" })
        self.moodCounts = grouped.map { MoodCount(emoji: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
        
        self.mostFrequentMood = moodCounts.first
        self.totalEntries = moods.count
        self.longestStreak = MoodStats.calculateLongestStreak(from: moods)
    }
    
    // MARK: - Streak Calculation
    /// Calculates the longest consecutive day streak.
    private static func calculateLongestStreak(from moods: [MoodEntry]) -> Int {
        // Convert each mood's timestamp to the start of its day.
        let dates = moods.compactMap { $0.timestamp?.stripTime() }.sorted()
        
        guard !dates.isEmpty else { return 0 }
        
        var longest = 1
        var current = 1
        
        for i in 1..<dates.count {
            // If the previous day plus one day equals the current day, increase the streak.
            if Calendar.current.isDate(dates[i - 1].addingDays(1), inSameDayAs: dates[i]) {
                current += 1
                longest = max(longest, current)
            } else if !Calendar.current.isDate(dates[i - 1], inSameDayAs: dates[i]) {
                current = 1
            }
        }
        
        return longest
    }
    
    // MARK: - Daily Data for Charts
    /// Groups moods by their date (with no time) and returns an array of tuples (label, count)
    var moodsPerDay: [(label: String, count: Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"  // Format as "15 Mar"
        
        // Group mood entries by the day (stripped of time).
        let grouped = Dictionary(grouping: moods) { entry in
            entry.timestamp?.stripTime() ?? Date()
        }
        
        // Map into a (label, count) tuple and sort by date.
        return grouped
            .map { (date, entries) in (date, entries.count) }
            .sorted { $0.0 < $1.0 }
            .map { (formatter.string(from: $0.0), $0.1) }
    }
}
