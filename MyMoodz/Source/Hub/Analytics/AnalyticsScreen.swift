//
//  AnalyticsScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 11/4/2025.
//

import SwiftUI

struct AnalyticsScreen: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Mood Overview")
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("😊 Happy")
                        Spacer()
                        Text("42%")
                    }
                    HStack {
                        Text("😢 Sad")
                        Spacer()
                        Text("18%")
                    }
                    HStack {
                        Text("😡 Angry")
                        Spacer()
                        Text("12%")
                    }
                    HStack {
                        Text("😐 Neutral")
                        Spacer()
                        Text("28%")
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
        }
    }
}
