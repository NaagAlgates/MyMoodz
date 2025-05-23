//
//  IpadMoodEntryPanel.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/5/2025.
//

import SwiftUI
struct IpadMoodEntryPanel: View {
    @ObservedObject var moodManager = MoodManager.shared
    @State private var note = ""
    @State private var now = Date()
    @State private var showSuccessToast = false

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Spacer(minLength: 0)

            VStack(spacing: 20) {
                HStack {
                    Text("How are you feeling?")
                        .font(.sfRounded(22, weight: .semibold))
                        .foregroundColor(moodManager.selectedColor)
                }

                if let last = moodManager.allMoodEntries.first {
                    HStack(spacing: 4) {
                        Text("Last mood:")
                            .foregroundColor(.gray)
                        Text(last.emoji ?? "")
                        Text(TimeAgoFormatter.format(last.timestamp ?? Date(), relativeTo: now))
                            .foregroundColor(.gray)
                    }
                    .font(.sfRounded(14, weight: .regular))
                }

                MoodGridView(
                    selectedMood: Binding<String>(
                        get: { moodManager.selectedEmoji ?? "" },
                        set: { moodManager.selectedEmoji = $0.isEmpty ? nil : $0 }
                    ),
                    moods: Mood.all
                )
                .padding(.horizontal)

                NoteInputView(note: $note, noteColorProxy: moodManager.selectedEmoji ?? "")
                    .padding(.horizontal)

                Button(action: {
                    if let emoji = moodManager.selectedEmoji {
                        MoodDataService.shared.saveMood(emoji: emoji, note: note)
                        moodManager.refreshMoods()
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
            }

            Spacer(minLength: 0)
        }
        .frame(maxHeight: .infinity)
        .padding()
        .onAppear {
            moodManager.refreshMoods()
        }
        .onReceive(timer) { _ in now = Date() }
    }

}
