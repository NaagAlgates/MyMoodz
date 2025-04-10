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

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var filteredEntries: [MoodEntry] {
        if searchText.isEmpty {
            return moodEntries
        }

        return moodEntries.filter { entry in
            let noteMatch = entry.note?.localizedCaseInsensitiveContains(searchText) ?? false
            let moodLabelMatch = Mood.label(forEmoji: entry.emoji ?? "").localizedCaseInsensitiveContains(searchText)
            return noteMatch || moodLabelMatch
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredEntries, id: \.self) { entry in
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
            .navigationTitle("Timeline")
            .searchable(text: $searchText, prompt: "Search mood or note")
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
