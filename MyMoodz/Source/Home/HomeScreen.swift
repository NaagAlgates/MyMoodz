//
//  ContentView.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var lastMoodEntry: MoodEntry?
    @State private var selectedMood: String = ""
    @State private var note = ""
    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .contentShape(Rectangle())

                VStack(spacing: 20) {
                    Text("How are you feeling?")
                        .font(.sfRounded(22, weight: .semibold))
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: MoodHubScreen()) {
                                    Image(systemName: "rectangle.grid.2x2")
                                }
                            }
                        }

                    if let last = lastMoodEntry {
                        HStack(spacing: 4) {
                            Text("Last mood:")
                                .foregroundColor(.gray)
                                .font(.footnote)
                            Text(last.emoji ?? "")
                                .font(.footnote)
                            Text(TimeAgoFormatter.format(last.timestamp ?? Date()))
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }

                    MoodGridView(selectedMood: $selectedMood, moods: Mood.all)
                        .padding(.horizontal)

                    NoteInputView(note: $note)
                        .padding(.horizontal)

                    Button(action: {
                        MoodDataService.shared.saveMood(emoji: selectedMood, note: note)
                        lastMoodEntry = MoodDataService.shared.fetchLatestMood()
                        Log.d("Mood: \(selectedMood), Note: \(note)")
                        selectedMood = ""
                        note = ""
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
                .offset(y: -keyboard.currentHeight * 0.1) // 👈 Smooth keyboard shift
                .animation(.easeInOut(duration: 0.3), value: keyboard.currentHeight)
            }
            .hideKeyboardOnTap()
        }
        .onAppear {
            lastMoodEntry = MoodDataService.shared.fetchLatestMood()
        }
    }

}
