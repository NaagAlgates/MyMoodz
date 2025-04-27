//
//  FilterOption.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 10/4/2025.
//

enum FilterOption: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case all, today, thisWeek, thisMonth

    var title: String {
        switch self {
        case .all: return "All Time"
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        }
    }
}
