//
//  ContentView.swift
//  My Moodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var lastMoodEntry: MoodEntry?
    @ObservedObject var moodManager = MoodManager.shared
    @State private var note = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var now = Date()
    @State private var showSuccessToast = false

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                    Color("BackgroundPrimary")
                    .ignoresSafeArea()
                    .contentShape(Rectangle())

                VStack(spacing: 20) {

                    ZStack {
                        Text("How are you feeling?")
                            .font(.sfRounded(22, weight: .semibold))
                            .foregroundColor(moodManager.selectedColor)
                            .animation(.easeInOut(duration: 0.3), value: moodManager.selectedColor)

                        HStack {
                            Spacer()
                            NavigationLink(destination: MoodHubScreen()) {
                                Image(systemName: "circle.grid.2x2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(moodManager.selectedColor)
                                    .animation(.easeInOut(duration: 0.3), value: moodManager.selectedColor)
                            }
                        }
                    }


                    // Last mood entry
                    if let last = lastMoodEntry {
                        HStack(spacing: 4) {
                            Text("Last mood:")
                                .foregroundColor(.gray)
                            Text(last.emoji ?? "")
                            Text(TimeAgoFormatter.format(last.timestamp ?? Date(), relativeTo: now))
                                .foregroundColor(.gray)
                        }
                        .font(.sfRounded(14, weight: .regular))
                    }

                    // Mood Picker
                    MoodGridView(
                        selectedMood: Binding<String>(
                            get: { moodManager.selectedEmoji ?? "" },
                            set: { moodManager.selectedEmoji = $0.isEmpty ? nil : $0 }
                        ),
                        moods: Mood.all
                    )
                    .padding(.horizontal)

                    // Note Input
                    NoteInputView(note: $note, noteColorProxy: moodManager.selectedEmoji ?? "")
                        .padding(.horizontal)

                    // Save Mood Button
                    Button(action: {
                        if let emoji = moodManager.selectedEmoji {
                            MoodDataService.shared.saveMood(emoji: emoji, note: note)
                            lastMoodEntry = MoodDataService.shared.fetchLatestMood()
                            Log.d("Mood: \(emoji), Note: \(note)")
                        }
                        moodManager.selectedEmoji = nil
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
                                (moodManager.selectedEmoji ?? "").isEmpty
                                ? Color.gray.opacity(0.4)
                                : moodManager.selectedColor
                            )
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .disabled((moodManager.selectedEmoji ?? "").isEmpty)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
                .offset(y: -keyboard.currentHeight * 0.1)
                .animation(.easeInOut(duration: 0.3), value: keyboard.currentHeight)
            }
            .onAppear {
                lastMoodEntry = MoodDataService.shared.fetchLatestMood()
            }
            .onReceive(timer) { _ in now = Date() }
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
                        }
                        .font(.sfRounded(16, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.95))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 80)
                    }
                },
                alignment: .top
            )
            .hideKeyboardOnTap()
        }
        .tint(moodManager.selectedColor)
    }
}
