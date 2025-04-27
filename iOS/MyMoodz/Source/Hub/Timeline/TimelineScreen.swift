//
//  TimelineScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import SwiftUI

struct TimelineScreen: View {
    @ObservedObject var moodManager = MoodManager.shared
    @State private var moodEntries: [MoodEntry] = []
    @State private var searchText = ""
    @State private var selectedEntry: MoodEntryData?
    @State private var now = Date()
    @State private var refreshTrigger = UUID()
    @State private var sortBy: SortOption = .newest
    @State private var filterBy: FilterOption = .all
    @State private var selectedDate: Date? = Date()
    @State private var isCalendarView: Bool = false
    @State private var dateIsAvailable: Bool = false
    
    var sortedDayEntries: [MoodEntry] {
        guard let selected = selectedDate else { return [] }

        return moodEntries
            .filter {
                guard let ts = $0.timestamp else { return false }
                return Calendar.current.isDate(ts, inSameDayAs: selected)
            }
            .sorted { a, b in
                if a.isPinned && !b.isPinned {
                    return true
                } else if !a.isPinned && b.isPinned {
                    return false
                }

                switch sortBy {
                case .newest:
                    return (a.timestamp ?? Date()) > (b.timestamp ?? Date())
                case .oldest:
                    return (a.timestamp ?? Date()) < (b.timestamp ?? Date())
                case .editedNewest:
                    return (a.modifiedAt ?? .distantPast) > (b.modifiedAt ?? .distantPast)
                case .editedOldest:
                    return (a.modifiedAt ?? .distantPast) < (b.modifiedAt ?? .distantPast)
                case .moodLabel:
                    return Mood.label(forEmoji: a.emoji ?? "") < Mood.label(forEmoji: b.emoji ?? "")
                case .emoji:
                    return (a.emoji ?? "") < (b.emoji ?? "")
                }
            }
    }


    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    var moodDates: [Date] {
           moodEntries.compactMap { $0.timestamp }
       }
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
        let entries = filteredEntries.sorted { a, b in
            if a.isPinned && !b.isPinned {
                return true
            } else if !a.isPinned && b.isPinned {
                return false
            }

            switch sortBy {
            case .newest:
                return (a.timestamp ?? Date()) > (b.timestamp ?? Date())
            case .oldest:
                return (a.timestamp ?? Date()) < (b.timestamp ?? Date())
            case .editedNewest:
                return (a.modifiedAt ?? .distantPast) > (b.modifiedAt ?? .distantPast)
            case .editedOldest:
                return (a.modifiedAt ?? .distantPast) < (b.modifiedAt ?? .distantPast)
            case .moodLabel:
                return Mood.label(forEmoji: a.emoji ?? "") < Mood.label(forEmoji: b.emoji ?? "")
            case .emoji:
                return (a.emoji ?? "") < (b.emoji ?? "")
            }
        }

        return entries
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("View Mode", selection: Binding(
                    get: { isCalendarView },
                    set: { newValue in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isCalendarView = newValue
                        }
                    }
                )) {
                    Text("List View").tag(false)
                    Text("Calendar View").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                ZStack{
                    if isCalendarView {
                        ScrollView {
                            VStack(spacing: 16) {
                                CalendarView(
                                    selectedDate: $selectedDate,
                                    moodDates: moodEntries.compactMap { $0.timestamp }
                                )
                                .padding(.horizontal)
                                let selectedDayEntries = sortedDayEntries
                                
                                
                                if !selectedDayEntries.isEmpty {
                                    VStack(spacing: 4){
                                        if let selected = selectedDate {
                                            Text("\(formattedDate(selected)):")
                                                .font(.title3)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .fontWeight(.semibold)
                                                .foregroundColor(moodManager.selectedColor)
                                                .padding()
                                                .animation(.easeInOut, value: selectedDate)
                                        }
                                        LazyVStack(spacing: 12) {
                                            ForEach(selectedDayEntries, id: \.self) { entry in
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
                                                    },
                                                    onUpdate: {
                                                        moodEntries = MoodDataService.shared.fetchAllMoods()
                                                        refreshTrigger = UUID()
                                                    }
                                                )
                                            }
                                        }
                                    }
                                } else {
                                    Text("No moods recorded on this day")
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            }
                        }
                    }
                    else {
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
                                        },
                                        onUpdate: {
                                            moodEntries = MoodDataService.shared.fetchAllMoods()
                                            refreshTrigger = UUID()
                                        }
                                    )
                                }
                            }
                            .padding(.top)
                            .id(refreshTrigger)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isCalendarView)
            .background(Color(.systemGroupedBackground))
            .overlay(
                Group {
                    if !isCalendarView {
                        Color.clear // Needed to maintain layout
                            .searchable(text: $searchText, prompt: "Search mood or note")
                            .textInputAutocapitalization(.never)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .animation(.easeInOut(duration: 0.3), value: isCalendarView)
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Group {
                        if !isCalendarView {
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
                                        .foregroundColor(moodManager.selectedColor.opacity(0.85))
                                }
                                .transition(.opacity.combined(with: .move(edge: .trailing)))

                                Menu {
                                    ForEach(FilterOption.allCases) { option in
                                        Button(option.title) {
                                            filterBy = option
                                        }
                                    }
                                } label: {
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                        .imageScale(.large)
                                        .foregroundColor(moodManager.selectedColor.opacity(0.85))
                                }
                                .transition(.opacity.combined(with: .move(edge: .trailing)))
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isCalendarView)
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
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}
