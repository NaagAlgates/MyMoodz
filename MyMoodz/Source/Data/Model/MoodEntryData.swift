//
//  MoodEntryData.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import Foundation

struct MoodEntryData: Identifiable, Equatable {
    let id: UUID
    var emoji: String
    var note: String
    var timestamp: Date

    init(from entry: MoodEntry) {
        self.id = entry.id ?? UUID()
        self.emoji = entry.emoji ?? ""
        self.note = entry.note ?? ""
        self.timestamp = entry.timestamp ?? Date()
    }
}
