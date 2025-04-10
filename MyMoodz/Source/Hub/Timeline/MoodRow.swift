//
//  MoodRow.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 10/4/2025.
//

import SwiftUI

struct MoodRow: View {
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
                        .foregroundColor(.gray)

                    if let modified = entry.modifiedAt {
                        Text("Edited \(TimeAgoFormatter.format(modified, relativeTo: now))")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }

                Spacer()
                Button {
                    MoodDataService.shared.togglePin(entry)
                    onUpdate()
                } label: {
                    Image(systemName: entry.isPinned ? "pin.circle.fill" : "pin.circle")
                        .foregroundColor(.orange)
                }
                Button(action: onEdit) {
                    Image(systemName: "pencil")
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
                    .foregroundColor(Color(UIColor.brown))
                    .padding(8)
                    .background(entry.isPinned ?nil: Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(entry.isPinned ? Color.orange.opacity(0.2) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(entry.isPinned ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
