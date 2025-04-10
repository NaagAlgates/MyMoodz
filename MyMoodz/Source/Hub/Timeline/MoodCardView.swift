//
//  MoodCardView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct MoodCardView: View {
    let entry: MoodEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Text(entry.emoji ?? "❓")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(Mood.label(forEmoji: entry.emoji ?? ""))
                        .font(.headline)

                    Text(TimeAgoFormatter.format(entry.timestamp ?? Date()))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
            }

            if let note = entry.note, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(note)
                    .font(.body)
                    .padding(8)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)

    }
}
