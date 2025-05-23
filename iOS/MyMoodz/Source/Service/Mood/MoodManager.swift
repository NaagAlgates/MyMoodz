//
//  MoodManager.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/4/2025.
//

import SwiftUI
import MessageUI
import Combine

class MoodManager: ObservableObject {
    static let shared = MoodManager() // Singleton for global access
    
    @Published var selectedEmoji: String? {
        didSet {
            if let emoji = selectedEmoji {
                selectedColor = SelectedMoodColor.color(for: emoji)
            }
        }
    }
    
    @Published var selectedColor: Color = Color.primary
    @Published var allMoodEntries: [MoodEntry] = []
    
    func refreshMoods() {
        self.allMoodEntries = MoodDataService.shared.fetchAllMoods()
    }
}
