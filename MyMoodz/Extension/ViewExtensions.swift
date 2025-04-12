//
//  ViewExtensions.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 12/4/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
