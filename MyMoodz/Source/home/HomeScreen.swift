//
//  ContentView.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct MoodOption: Identifiable {
    let id = UUID()
    let emoji: String
    let label: String
}

struct HomeScreen: View {
    @State private var selectedMood: String = ""
    @State private var note: String = ""

    let moods: [MoodOption] = [
        MoodOption(emoji: "😄", label: "Happy"),
        MoodOption(emoji: "🙂", label: "Content"),
        MoodOption(emoji: "😐", label: "Neutral"),
        MoodOption(emoji: "😢", label: "Sad"),
        MoodOption(emoji: "😡", label: "Angry"),
        MoodOption(emoji: "🤯", label: "Stressed"),
        MoodOption(emoji: "😴", label: "Tired"),
        MoodOption(emoji: "😰", label: "Anxious"),
        MoodOption(emoji: "😆", label: "Excited"),
        MoodOption(emoji: "🥰", label: "Loved"),
        MoodOption(emoji: "😶‍🌫️", label: "Confused"),
        MoodOption(emoji: "🤗", label: "Hopeful")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How are you feeling?")
                    .font(.sfRounded(22, weight: .semibold))

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                    ForEach(moods) { mood in
                        VStack {
                            Text(mood.emoji)
                                .font(.largeTitle)
                                .padding()
                                .background(selectedMood == mood.emoji ? Color.blue.opacity(0.3) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedMood = mood.emoji
                                }
                            Text(mood.label)
                                .font(.caption.weight(selectedMood == mood.emoji ? .bold : .regular))
                                .foregroundColor(.primary)
                        }
                    }
                }

                TextField("Add a short note...", text: $note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Save Mood (not wired yet)") {
                    print("Mood: \(selectedMood), Note: \(note)")
                }
                .disabled(selectedMood.isEmpty)

                Spacer()
            }
            .padding()
        }
    }
}
