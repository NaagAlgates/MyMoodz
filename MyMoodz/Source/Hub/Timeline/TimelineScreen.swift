//
//  TimelineScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import SwiftUI

struct TimelineScreen: View {
    @State private var moodEntries: [MoodEntry] = []
    @State private var searchText = ""
    @State private var selectedEntry: MoodEntryData?
    @State private var now = Date()
    @State private var refreshTrigger = UUID()
    @State private var sortBy: SortOption = .newest
    @State private var filterBy: FilterOption = .all


    
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var filteredEntries: [MoodEntry] {
        let dateFiltered = moodEntries.filter { entry in
            guard let timestamp = entry.timestamp else { return false }
            switch filterBy {
            case .all: return true
            case .today: return Calendar.current.isDateInToday(timestamp)
            case .thisWeek:
                return Calendar.current.isDate(timestamp, equalTo: Date(), toGranularity: .weekOfYear)
            case .thisMonth:
                return Calendar.current.isDate(timestamp, equalTo: Date(), toGranularity: .month)
            }
        }

        if searchText.isEmpty {
            return dateFiltered
        }

        return dateFiltered.filter { entry in
            let emojiMatches = (entry.emoji ?? "").trimmingCharacters(in: .whitespacesAndNewlines) == searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let noteMatches = entry.note?.localizedCaseInsensitiveContains(searchText) ?? false
            let labelMatches = Mood.label(forEmoji: entry.emoji ?? "")
                .localizedCaseInsensitiveContains(searchText)
            return emojiMatches || labelMatches || noteMatches
        }
    }

    
    var sortedFilteredEntries: [MoodEntry] {
        let entries = filteredEntries
        switch sortBy {
        case .newest:
            return entries.sorted { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }
        case .oldest:
            return entries.sorted { ($0.timestamp ?? Date()) < ($1.timestamp ?? Date()) }
        case .editedNewest:
            return entries.sorted { ($0.modifiedAt ?? Date.distantPast) > ($1.modifiedAt ?? Date.distantPast) }
        case .editedOldest:
            return entries.sorted { ($0.modifiedAt ?? Date.distantPast) < ($1.modifiedAt ?? Date.distantPast) }
        case .moodLabel:
            return entries.sorted {
                Mood.label(forEmoji: $0.emoji ?? "") < Mood.label(forEmoji: $1.emoji ?? "")
            }
        case .emoji:
            return entries.sorted { ($0.emoji ?? "") < ($1.emoji ?? "") }
        }
    }



    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(sortedFilteredEntries, id: \.self) { entry in
                        MoodRow(
                            entry: entry,
                            now: now,
                            onEdit: {
                                selectedEntry = MoodEntryData(from: entry)
                            },
                            onDelete: {
                                MoodDataService.shared.deleteMood(entry)
                                moodEntries = MoodDataService.shared.fetchAllMoods()
                                refreshTrigger = UUID()
                            }
                        )
                    }
                }
                .padding(.top)
                .id(refreshTrigger)
            }
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Search mood or note")
            .textInputAutocapitalization(.never)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Menu {
                            ForEach(SortOption.allCases) { option in
                                Button(option.title) {
                                    sortBy = option
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }

                        Menu {
                            ForEach(FilterOption.allCases) { option in
                                Button(option.title) {
                                    filterBy = option
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }


        }
        .sheet(item: $selectedEntry) { entryData in
            EditMoodSheet(entryData: entryData) {
                moodEntries = MoodDataService.shared.fetchAllMoods()
                refreshTrigger = UUID()
                selectedEntry = nil
            }
        }
        .onAppear {
            moodEntries = MoodDataService.shared.fetchAllMoods()
        }
        .onReceive(timer) { _ in
            now = Date()
        }
    }
}
