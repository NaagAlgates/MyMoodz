//
//  SelectedMoodColor.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 22/4/2025.
//

import SwiftUI

struct SelectedMoodColor {
    static func color(for emoji: String) -> Color {
        switch emoji {
        case "😄": return .yellow
        case "😌": return .blue
        case "😐": return .brown
        case "😢": return .purple
        case "😡": return .red
        case "🤯": return .orange
        case "😴": return .teal
        case "😰": return .mint
        case "🤣": return .green
        case "🥰": return .cyan
        case "🫥": return .indigo
        case "🤗": return .green
        default: return .black
        }
    }
}
