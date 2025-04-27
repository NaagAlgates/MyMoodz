//
//  PieChartViewWrapper.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 15/4/2025.
//

import SwiftUI
import DGCharts

struct PieChartViewWrapper: UIViewRepresentable {
    // Data is an array of MoodStats.MoodCount (your model)
    var data: [MoodStats.MoodCount]
    
    // A binding that will hold the selected slice's value as text.
    @Binding var selectedValue: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> PieChartView {
        let pieChart = PieChartView()
        
        // Donut style
        pieChart.usePercentValuesEnabled = false
        pieChart.drawHoleEnabled = true
        pieChart.holeRadiusPercent = 0.35
        pieChart.transparentCircleColor = .clear
        pieChart.chartDescription.enabled = false
        pieChart.drawEntryLabelsEnabled = false
        
        // Set delegate so we get tap events
        pieChart.delegate = context.coordinator
        
        // Legend (optional, adjust as needed)
        pieChart.legend.enabled = false
        pieChart.legend.horizontalAlignment = .center
        pieChart.legend.verticalAlignment = .bottom
        
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        // Create entries from the data
        let entries = data.map { mood in
            PieChartDataEntry(value: Double(mood.count), label: mood.emoji)
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "Mood Distribution")
        // Use a color template or your own palette
        dataSet.colors = ChartColorTemplates.material()
        // IMPORTANT: Do not draw values by default.
        dataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: dataSet)
        
        // Set the center text based on selection
        if let selected = selectedValue {
            uiView.centerText = selected
        } else {
            uiView.centerText = "Moods"
        }
        
        uiView.data = chartData
        uiView.notifyDataSetChanged()
    }
    
    // Coordinator to act as delegate for the chart
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: PieChartViewWrapper
        
        init(_ parent: PieChartViewWrapper) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            // When a slice is tapped, update the selected value.
            if let pieEntry = entry as? PieChartDataEntry, let label = pieEntry.label {
                // Show the emoji and the whole number count
                parent.selectedValue = "\(label): \(Int(pieEntry.value))"
            }
        }
        
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            // Clear selection when nothing is tapped.
            parent.selectedValue = nil
        }
    }
}
