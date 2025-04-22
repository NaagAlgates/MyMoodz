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
    @State private var now = Date()
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    @State private var showSuccessToast = false



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
                                        .foregroundColor(SelectedMoodColor.color(for: selectedMood))
                                }
                            }
                        }

                    if let last = lastMoodEntry {
                        HStack(spacing: 4) {
                            Text("Last mood:")
                                .foregroundColor(.gray)
                                .font(.sfRounded(14, weight: .regular))
                            Text(last.emoji ?? "")
                                .font(.sfRounded(14, weight: .regular))
                            Text(TimeAgoFormatter.format(last.timestamp ?? Date(), relativeTo: now))
                                .foregroundColor(.gray)
                                .font(.sfRounded(14, weight: .regular))

                        }
                    }

                    MoodGridView(selectedMood: $selectedMood, moods: Mood.all)
                        .padding(.horizontal)

                    NoteInputView(note: $note, noteColorProxy: selectedMood)
                        .padding(.horizontal)

                    Button(action: {
                        MoodDataService.shared.saveMood(emoji: selectedMood, note: note)
                        lastMoodEntry = MoodDataService.shared.fetchLatestMood()
                        Log.d("Mood: \(selectedMood), Note: \(note)")
                        selectedMood = ""
                        note = ""
                        showSuccessToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessToast = false
                        }
                    }) {
                        Text("Save Mood")
                            .font(.sfRounded(16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedMood.isEmpty
                                ? Color.gray.opacity(0.4)
                                : SelectedMoodColor.color(for: selectedMood)
                            )
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .animation(.easeInOut(duration: 0.2), value: selectedMood)
                    }
                    .disabled(selectedMood.isEmpty)
                    .padding(.horizontal)
                    .scaleEffect(showSuccessToast ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: showSuccessToast)
                    
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
        .onReceive(timer) { _ in
            now = Date()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            now = Date()
        }
        .overlay(
            Group {
                if showSuccessToast {
                    HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text("Mood saved successfully!")
                                .font(.sfRounded(16, weight: .semibold))
                        }
                        .font(.sfRounded(16, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.95))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.25), value: showSuccessToast)
                        .padding(.top, 80)
                }
            },
            alignment: .top
        )

    }

}
