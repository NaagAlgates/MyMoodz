import SwiftUI

struct CalendarView: View {
    @ObservedObject var moodManager = MoodManager.shared
    @State private var baseDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date?
    var moodDates: [Date]

    // MARK: - Calendar with Monday start
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }()

    @State private var currentMonthOffset = 0
    @State private var currentYearOffset = 0
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "LLLL yyyy" // Example: April 2025
        return df
    }()

    var displayedDate: Date {
        calendar.date(byAdding: .month, value: currentMonthOffset + currentYearOffset * 12, to: baseDate) ?? baseDate
    }

    var body: some View {
        VStack(spacing: 12) {
            // Navigation
            HStack {
                Button { currentYearOffset -= 1 } label: {
                    Image(systemName: "chevron.left.2")
                }

                Button { currentMonthOffset -= 1 } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(formatter.string(from: displayedDate))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(moodManager.selectedColor)

                Spacer()

                Button { currentMonthOffset += 1 } label: {
                    Image(systemName: "chevron.right")
                }

                Button { currentYearOffset += 1 } label: {
                    Image(systemName: "chevron.right.2")
                }
            }
            .padding(.horizontal)

            // Go to Today Button
            if !calendar.isDateInToday(displayedDate) {
                Button {
                    currentMonthOffset = 0
                    currentYearOffset = 0
                    selectedDate = Date()
                } label: {
                    Text("Go to Today")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                .transition(.opacity)
                .padding(.top, 4)
            }

            // Weekday Headers
            let weekdays = calendar.shortWeekdaySymbols
            let startIndex = calendar.firstWeekday - 1
            let reorderedWeekdays = Array(weekdays[startIndex..<weekdays.count] + weekdays[0..<startIndex])

            HStack {
                ForEach(reorderedWeekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(moodManager.selectedColor)
                        .font(.caption)
                }
            }

            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(getCalendarDays(), id: \.self) { date in
                    if let dayDate = date {
                        ZStack {
                            if isToday(dayDate) || dayIsSelected(dayDate) || isMoodDay(dayDate) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isToday(dayDate) ? moodManager.selectedColor.opacity(0.2) : Color.white.opacity(0.8))
                                    .shadow(color: Color.white.opacity(0.2), radius: 2, x: 0, y: 2)
                                    .frame(width: 40, height: 40)
                            }

                            VStack(spacing: 2) {
                                Text("\(calendar.component(.day, from: dayDate))")
                                    .foregroundColor(dayIsAvailable(dayDate) || isMoodDay(dayDate) ? .primary : .gray)
                                    .fontWeight(dayIsSelected(dayDate) ? .bold : .regular)

                                if isMoodDay(dayDate) {
                                    Circle()
                                        .fill(moodManager.selectedColor)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            if isToday(dayDate) || isMoodDay(dayDate) {
                                selectedDate = dayDate
                            }
                        }
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding()
        }
        .padding(.top)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.top)
        .onAppear {
            baseDate = selectedDate ?? Date()
        }
    }

    // MARK: - Helpers

    func getCalendarDays() -> [Date?] {
        let range = calendar.range(of: .day, in: .month, for: displayedDate)!
        let components = calendar.dateComponents([.year, .month], from: displayedDate)
        let firstDayOfMonth = calendar.date(from: components)!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)

        let offset = (weekday - calendar.firstWeekday + 7) % 7
        var days: [Date?] = Array(repeating: nil, count: offset)

        for day in range {
            var dayComponents = components
            dayComponents.day = day
            if let date = calendar.date(from: dayComponents) {
                days.append(date)
            }
        }

        return days
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func dayIsSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }

    func dayIsAvailable(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isMoodDay(_ date: Date) -> Bool {
        moodDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }

    func isDateInFuture(_ date: Date) -> Bool {
        return date > Date()
    }
}
