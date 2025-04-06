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
    @State private var refreshTrigger = UUID() // 👈 for forcing view update

    var filteredEntries: [MoodEntry] {
        if searchText.isEmpty {
            return moodEntries
        }

        return moodEntries.filter { entry in
            let noteMatch = entry.note?.localizedCaseInsensitiveContains(searchText) ?? false
            let labelMatch = Mood.label(forEmoji: entry.emoji ?? "").localizedCaseInsensitiveContains(searchText)
            return noteMatch || labelMatch
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredEntries, id: \.self) { entry in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                Text(entry.emoji ?? "❓")
                                    .font(.largeTitle)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(Mood.label(forEmoji: entry.emoji ?? ""))
                                        .font(.headline)
                                    Text(TimeAgoFormatter.format(entry.timestamp ?? Date()))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                // Edit button
                                Button {
                                    selectedEntry = MoodEntryData(from: entry)
                                } label: {
                                    Image(systemName: "pencil")
                                }
                                .padding(.trailing, 4)

                                // Delete button
                                Button {
                                    MoodDataService.shared.deleteMood(entry)
                                    moodEntries = MoodDataService.shared.fetchAllMoods()
                                    refreshTrigger = UUID()
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }

                            if let note = entry.note, !note.isEmpty {
                                Text(note)
                                    .font(.body)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .id(refreshTrigger) // 👈 Force refresh after update
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
    }
}
