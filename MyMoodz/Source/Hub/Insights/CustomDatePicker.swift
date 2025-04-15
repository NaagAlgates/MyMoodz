//
//  CustomDatePicker.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 15/4/2025.
//

import SwiftUI

struct CustomDatePicker: UIViewRepresentable {
    @Binding var selection: Date
    var datePickerMode: UIDatePicker.Mode = .date
    var locale: Locale = Locale(identifier: "en_AU")

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = datePickerMode
        picker.locale = locale
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selection
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CustomDatePicker
        init(_ parent: CustomDatePicker) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selection = sender.date
        }
    }
}
