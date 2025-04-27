//
//  MoodHubView.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 6/4/2025.
//
import SwiftUI

struct MoodHubScreen: View {
    @ObservedObject var moodManager = MoodManager.shared
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
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(moodManager.selectedColor)
        .animation(.easeInOut(duration: 0.3), value: moodManager.selectedColor)
    }
}
