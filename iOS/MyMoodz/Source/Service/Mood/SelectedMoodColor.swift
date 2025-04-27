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
        case "😄": return Color(hex: "#F9A825")
        case "😌": return Color(hex: "#4FC3F7")
        case "😐": return Color(hex: "#90A4AE")
        case "😢": return Color(hex: "#3949AB")
        case "😡": return Color(hex: "#D32F2F")
        case "🤯": return Color(hex: "#F57C00")
        case "😴": return Color(hex: "#5C6BC0")
        case "😰": return Color(hex: "#26C6DA")
        case "🤣": return Color(hex: "#43A047")
        case "🥰": return Color(hex: "#EC407A")
        case "🤔": return Color(hex: "#303F9F")
        case "🤗": return Color(hex: "#66BB6A")
        default: return .black
        }
    }
}
