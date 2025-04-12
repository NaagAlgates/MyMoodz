import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date?
    var moodDates: [Date]
    let calendar = Calendar.current
    @State private var currentMonthOffset = 0
    @State private var currentYearOffset = 0
    
    var displayedDate: Date {
        calendar.date(
            byAdding: .year,
            value: currentYearOffset,
            to: calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
        ) ?? Date()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Month & Year Navigation
            HStack {
                Button(action: {
                    currentYearOffset -= 1
                }) {
                    Image(systemName: "chevron.left.2")
                }
                
                Button(action: {
                    currentMonthOffset -= 1
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text("\(calendar.monthSymbols[calendar.component(.month, from: displayedDate) - 1]) \(String(calendar.component(.year, from: displayedDate)))")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    currentMonthOffset += 1
                }) {
                    Image(systemName: "chevron.right")
                }
                
                Button(action: {
                    currentYearOffset += 1
                }) {
                    Image(systemName: "chevron.right.2")
                }
            }
            .padding(.horizontal)
            if !calendar.isDateInToday(displayedDate) {
                Button(action: {
                    currentMonthOffset = 0
                    currentYearOffset = 0
                    selectedDate = Date()
                }) {
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
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(getDatesForCurrentMonth(), id: \.self) { day in
                    let dayDate = setDateForDay(day)

                    ZStack {
                        if isToday(dayDate) || dayIsSelected(dayDate) || isMoodDay(dayDate) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isToday(dayDate) ? Color.blue.opacity(0.2) : Color.white.opacity(0.8))
                                .shadow(color: Color.white.opacity(0.2), radius: 2, x: 0, y: 2)
                                .frame(width: 40, height: 40)
                        }

                        VStack(spacing: 2) {
                            Text("\(day)")
                                .foregroundColor(dayIsAvailable(dayDate) || isMoodDay(dayDate) ? .primary : .gray)
                                .fontWeight(dayIsSelected(dayDate) ? .bold : .regular)

                            if isMoodDay(dayDate) {
                                Circle()
                                    .fill(Color.blue)
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
                }
            }
            .padding()
        }
        .padding(.top)
    }
    
    // MARK: - Helpers
    
    func getDatesForCurrentMonth() -> [Int] {
        let range = calendar.range(of: .day, in: .month, for: displayedDate)!
        return Array(range)
    }
    
    func setDateForDay(_ day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: displayedDate)
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
    
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    func dayIsSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }
    
    func dayIsAvailable(_ date: Date) -> Bool {
        calendar.isDateInToday(date) // You can customize this logic if needed
    }
    
    func isMoodDay(_ date: Date) -> Bool {
        moodDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    func isDateInFuture(_ date: Date) -> Bool {
        return date > Date()
    }

}
