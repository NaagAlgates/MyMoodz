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

                    Button(action: {
                        Log.d("Mood: \(selectedMood), Note: \(note)")
                    }) {
                        Text("Save Mood")
                            .font(.sfRounded(16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedMood.isEmpty
                                ? Color.gray.opacity(0.4)
                                : Color.blue
                            )
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .animation(.easeInOut(duration: 0.2), value: selectedMood)
                    }
                    .disabled(selectedMood.isEmpty)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            .hideKeyboardOnTap()
        }
    }
}
