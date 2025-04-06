//
//  TimeAgoFormatter.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import Foundation

struct TimeAgoFormatter {
    static func format(_ date: Date, relativeTo now: Date = Date()) -> String {
        let seconds = now.timeIntervalSince(date)

        let minute = 60.0
        let hour = 3600.0
        let day = 86400.0
        let week = 604800.0
        let month = 2_592_000.0

        switch seconds {
        case 0..<30:
            return "Just now"
        case 30..<60:
            return "30 sec ago"
        case 60..<hour:
            let minutes = Int(seconds / minute)
            return "\(minutes) min\(minutes == 1 ? "" : "s") ago"
        case hour..<day:
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        case day..<2 * day:
            return "Yesterday"
        case 2 * day..<week:
            let days = Int(seconds / day)
            return "\(days) days ago"
        case week..<2 * week:
            return "A week ago"
        case 2 * week..<month:
            let weeks = Int(seconds / week)
            return "\(weeks) weeks ago"
        case month..<2 * month:
            return "A month ago"
        default:
            let months = Int(seconds / month)
            return months <= 0 ? "Just now" : "\(months) months ago"
        }
    }
}
