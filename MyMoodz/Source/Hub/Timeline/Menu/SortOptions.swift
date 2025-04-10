//
//  Sort.swift.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 10/4/2025.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case newest
    case oldest
    case moodLabel
    case emoji
    case editedNewest
    case editedOldest

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .newest: return "Created (Newest First)"
        case .oldest: return "Created (Oldest First)"
        case .moodLabel: return "Mood A–Z"
        case .emoji: return "Emoji"
        case .editedNewest: return "Edited (Newest First)"
        case .editedOldest: return "Edited (Oldest First)"
        }
    }
}
