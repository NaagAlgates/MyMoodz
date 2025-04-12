//
//  AnalyticsScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//

import SwiftUI

struct InsightsScreen: View {
    @State private var moodHistory: [Mood] = Mood.all
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Detailed Insights")
                    .font(.title)
                    .bold()
                    .padding()
                
                // Example Insights
                Text("You tend to feel happier on weekends.")
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                
                Text("Your most frequent mood is 'Happy'.")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                
                // A list of mood events, if any
                ForEach(moodHistory) { mood in
                    Text("\(mood.label): \(mood.emoji)")
                }
            }
            .padding()
        }
    }
}
