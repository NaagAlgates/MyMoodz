//
//  MoodHubView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import SwiftUI

struct MoodHubScreen: View {
    var body: some View {
        TabView {
            TimelineScreen()
                .tabItem {
                    Label("Timeline", systemImage: "clock")
                }

            InsightsScreen()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.xaxis")
                }
        }
    }
}
