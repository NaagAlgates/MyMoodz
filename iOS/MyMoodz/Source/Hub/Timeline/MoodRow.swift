//
//  MoodRow.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 10/4/2025.
//

import SwiftUI

struct MoodRow: View {
    @ObservedObject var moodManager = MoodManager.shared

    let entry: MoodEntry
    let now: Date
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onUpdate: () -> Void


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(entry.emoji ?? "❓")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 4) {
                    Text(Mood.label(forEmoji: entry.emoji ?? ""))
                        .font(.headline)

                    Text(TimeAgoFormatter.format(entry.timestamp ?? now, relativeTo: now))
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.5))

                    if let modified = entry.modifiedAt {
                        Text("Edited \(TimeAgoFormatter.format(modified, relativeTo: now))")
                            .font(.caption2)
                            .foregroundColor(moodManager.selectedColor.opacity(0.7))
                    }
                }

                Spacer()
                Button {
                    MoodDataService.shared.togglePin(entry)
                    onUpdate()
                } label: {
                    Image(systemName: entry.isPinned ? "pin.circle.fill" : "pin.circle")
                        .foregroundColor(moodManager.selectedColor.opacity(0.9))

                }
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.blue.opacity(0.7))
                }
                .padding(.trailing, 4)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }

            if let note = entry.note, !note.isEmpty {
                Text(note)
                    .font(.body)
                    .foregroundColor(entry.isPinned ? moodManager.selectedColor.opacity(0.9) : Color(UIColor.brown))
                    .padding(8)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(
            Group {
                if entry.isPinned {
                    moodManager.selectedColor.opacity(0.2)
                } else {
                    Color.white
                }
            }
        )
        .brightness(entry.isPinned ? 0.1 : 0)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(entry.isPinned ? moodManager.selectedColor.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
