//
//  IpadHomeScreen.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 23/5/2025.
//
import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case timeline, insights, settings

    var id: String { rawValue }
}

struct IPadHomeScreen: View {
    @State private var selectedTab: Tab = .timeline

    var body: some View {
        HStack(spacing: 0) {
            IpadMoodEntryPanel()
                .frame(width: UIScreen.main.bounds.width * 0.35)
                .background(Color("BackgroundPrimary"))

            Divider()

            VStack(spacing: 0) {
                Picker("Select Tab", selection: $selectedTab) {
                    ForEach(Tab.allCases) { tab in
                        Text(tab.rawValue.capitalized).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color(.systemGroupedBackground))

                Divider()

                Group {
                    switch selectedTab {
                    case .timeline:
                        TimelineScreen()
                    case .insights:
                        InsightsScreen()
                    case .settings:
                        SettingsScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.secondarySystemBackground))
        }
    }
}
