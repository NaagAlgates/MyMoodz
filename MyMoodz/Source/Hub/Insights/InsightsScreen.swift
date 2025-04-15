//
//  AnalyticsScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct InsightsScreen: View {
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    @State private var moodStats = MoodStats(moods: [])
    @State private var pieSelectedValue: String? = nil
    
    private var filteredMoods: [MoodEntry] {
        MoodDataService.shared.fetchAllMoods().filter {
            guard let date = $0.timestamp else { return false }
            return date >= startDate && date <= endDate
        }
    }
    
    private var dailyTrend: [Double] {
        let calendar = Calendar.current
        var trend: [Double] = []
        var date = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        
        while date <= end {
            let count = filteredMoods.filter { mood in
                if let ts = mood.timestamp {
                    return calendar.isDate(ts, inSameDayAs: date)
                }
                return false
            }.count
            trend.append(Double(count))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return trend
    }
    
    // Generate labels for the daily trend chart.
    private var dailyLabels: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let calendar = Calendar.current
        var labels: [String] = []
        var date = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        
        while date <= end {
            labels.append(formatter.string(from: date))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return labels
    }
    
    private func weekdayName(from weekdayNumber: Int) -> String {
        switch weekdayNumber {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Unknown"
        }
    }

    /// Defines the custom order: Monday=0, Tuesday=1, ... Sunday=6.
    private let weekdayOrder: [String: Int] = [
        "Monday": 0,
        "Tuesday": 1,
        "Wednesday": 2,
        "Thursday": 3,
        "Friday": 4,
        "Saturday": 5,
        "Sunday": 6
    ]
    
    private var weekdayDistribution: [(String, Int)] {
        let calendar = Calendar.current
        // Filter moods by the date range
        let moods = MoodDataService.shared.fetchAllMoods().filter {
            guard let date = $0.timestamp else { return false }
            return date >= startDate && date <= endDate
        }
        
        // Group by the weekday number
        let grouped = Dictionary(grouping: moods) { mood -> String in
            let dayIndex = calendar.component(.weekday, from: mood.timestamp ?? Date()) // Sunday=1, Monday=2
            return weekdayName(from: dayIndex) // e.g. "Monday"
        }

        // Convert the dictionary to an array of (weekdayName, count)
        let array = grouped.map { (weekdayName, entries) in
            (weekdayName, entries.count)
        }
        
        // Sort by our custom order, so Monday -> Tuesday -> ... -> Sunday
        return array.sorted { weekdayOrder[$0.0, default: 7] < weekdayOrder[$1.0, default: 7] }
    }



    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Insights from \(formatted(startDate)) to \(formatted(endDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical)

                    HStack(alignment: .center, spacing: 20) {
                        DatePicker(
                            "",
                            selection: $startDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "en_AU"))

                        Spacer()

                        DatePicker(
                            "",
                            selection: $endDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "en_AU"))
                    }

                    Button("Reset") {
                        resetDateRange()
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    StatCard(title: "Most Frequent", value: moodStats.mostFrequentMood?.emoji ?? "🙂")
                    StatCard(title: "Total Moods", value: "\(moodStats.totalEntries) 🎉")
                    StatCard(title: "Longest Streak", value: "\(moodStats.longestStreak) 🔥")
                }
                .padding(.horizontal)

                Text("Mood Entries Per Day")
                    .font(.headline)
                    .padding(.horizontal)

                BarChartViewWrapper(data: moodStats.moodsPerDay)
                    .frame(height: 200)
                    .padding(.horizontal)
                
                Text("Mood Distribution")
                    .font(.headline)
                    .padding(.horizontal)
                                
                PieChartViewWrapper(data: moodStats.moodCounts, selectedValue: $pieSelectedValue)
                    .frame(height: 260)
                    .padding(.horizontal)
                
                Text("Daily Mood Trend")
                   .font(.headline)
                   .padding(.horizontal)
               LineChartViewWrapper(data: dailyTrend, labels: dailyLabels)
                   .frame(height: 220)
                   .padding(.horizontal)
                
                Text("Moods by Weekday")
                    .font(.headline)
                    .padding(.horizontal)
                
                HorizontalBarChartViewWrapper(data: weekdayDistribution)
                    .frame(height: 200)
                    .padding(.horizontal)

                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .onAppear {
            moodStats = MoodStats(moods: filteredMoods)
            resetDateRange()
        }
        .onChange(of: startDate) {
            moodStats = MoodStats(moods: filteredMoods)
        }
        .onChange(of: endDate) {
            moodStats = MoodStats(moods: filteredMoods)
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func resetDateRange() {
        startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        endDate = Date()
    }
}
