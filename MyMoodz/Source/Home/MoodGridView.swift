//
//  MoodGridView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI


struct Mood: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    let label: String
    
    static func label(forEmoji emoji: String) -> String {
        all.first(where: { $0.emoji == emoji })?.label ?? "Unknown"
    }

    static let all: [Mood] = [
        .init(emoji: "😄", label: "Happy"),
        .init(emoji: "😌", label: "Calm"),
        .init(emoji: "😐", label: "Neutral"),
        .init(emoji: "😢", label: "Sad"),
        .init(emoji: "😡", label: "Angry"),
        .init(emoji: "🤯", label: "Stressed"),
        .init(emoji: "😴", label: "Tired"),
        .init(emoji: "😰", label: "Anxious"),
        .init(emoji: "🤣", label: "Excited"),
        .init(emoji: "🥰", label: "Loved"),
        .init(emoji: "🫥", label: "Confused"),
        .init(emoji: "🤗", label: "Hopeful")
    ]
}

struct MoodGridView: View {
    @Binding var selectedMood: String
    let moods: [Mood]

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(moods) { mood in
                VStack {
                    Text(mood.emoji)
                        .font(.largeTitle)
                        .padding()
                        .background(selectedMood == mood.emoji ? Color.blue.opacity(0.3) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            if selectedMood == mood.emoji {
                                selectedMood = ""
                            } else {
                                selectedMood = mood.emoji
                            }
                        }

                    Text(mood.label)
                        .font(.caption.weight(selectedMood == mood.emoji ? .bold : .regular))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
