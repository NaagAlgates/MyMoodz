//
//  ContentView.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedMood: String = ""
    @State private var note = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .contentShape(Rectangle())

                VStack(spacing: 20) {
                    Text("How are you feeling?")
                        .font(.sfRounded(22, weight: .semibold))

                    MoodGridView(selectedMood: $selectedMood, moods: Mood.all)
                        .padding(.horizontal)

                    NoteInputView(note: $note)
                        .padding(.horizontal)

                    Button("Save Mood (not wired yet)") {
                        print("Mood: \(selectedMood), Note: \(note)")
                    }
                    .disabled(selectedMood.isEmpty)

                    Spacer()
                }
                .padding()
            }
            .hideKeyboardOnTap()
        }
    }
}
