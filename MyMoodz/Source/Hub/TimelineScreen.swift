//
//  TimelineScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct TimelineScreen: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10, id: \.self) { index in
                    HStack {
                        Text("😊")
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text("Happy")
                                .font(.headline)
                            Text("Note: Felt great today!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("10:34 AM")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Timeline")
        }
    }
}
