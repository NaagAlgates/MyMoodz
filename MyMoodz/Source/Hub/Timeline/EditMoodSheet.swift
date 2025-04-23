//
//  EditMoodSheet.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import SwiftUI

struct EditMoodSheet: View {
    var entry: MoodEntryData
    @State private var note: String
    @State private var selectedMood: String
    var onSave: () -> Void

    @ObservedObject private var keyboard = KeyboardResponder()
    @Environment(\.dismiss) private var dismiss

    init(entryData: MoodEntryData, onSave: @escaping () -> Void) {
        self.entry = entryData
        self._note = State(initialValue: entryData.note)
        self._selectedMood = State(initialValue: entryData.emoji)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    Text("Select Mood")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    MoodGridView(selectedMood: $selectedMood, moods: Mood.all)
                        .padding(.horizontal)

                    Text("Edit Note")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextEditor(text: $note)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2))
                        )
                        .padding(.horizontal)

                    Spacer()

                    Button("Save Changes") {
                        if let original = MoodDataService.shared.fetchEntry(by: entry.id) {
                           MoodDataService.shared.updateMood(original, newNote: note, newEmoji: selectedMood)
                           onSave()
                           dismiss()
                       }
                    }
                    .font(.sfRounded(16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
                .offset(y: -keyboard.currentHeight * 0.1)
                .animation(.easeInOut(duration: 0.3), value: keyboard.currentHeight)
            }
            .hideKeyboardOnTap()
            .navigationTitle("Edit Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
