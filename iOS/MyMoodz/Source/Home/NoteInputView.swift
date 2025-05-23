//
//  NoteInputView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct NoteInputView: View {
    @Binding var note: String
    var noteColorProxy: String
    @FocusState private var isFocused: Bool

    var body: some View {
        TextEditor(text: $note)
            .scrollContentBackground(.hidden)
            .padding(12)
            .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("NoteBackground"))
                )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isFocused
                        ? SelectedMoodColor.color(for: noteColorProxy).opacity(0.8)
                        : Color.gray.opacity(0.4),
                        lineWidth: 1
                    )
            )
            .frame(minHeight: 100, maxHeight: 200)
            .focused($isFocused)
            .foregroundColor(Color("NoteText"))
            .overlay(
                Group {
                    if note.isEmpty {
                        Text("Add a short note (optional)")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                },
                alignment: .topLeading
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .font(.sfRounded(16, weight: .regular))
    }
}
