//
//  HorizontalBarChartViewWrapper.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 15/4/2025.
//

import SwiftUI
import DGCharts // This is the module from the Charts package

struct HorizontalBarChartViewWrapper: UIViewRepresentable {
    // Data: an array of tuples (label, count)
    var data: [(String, Int)]

    func makeUIView(context: Context) -> HorizontalBarChartView {
        let chart = HorizontalBarChartView()
        chart.legend.enabled = false
        chart.rightAxis.enabled = false
        // Hide leftAxis if you don't want values there
        chart.leftAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.granularity = 1
        chart.xAxis.drawGridLinesEnabled = false
        return chart
    }

    func updateUIView(_ uiView: HorizontalBarChartView, context: Context) {
        let entries = data.enumerated().map { (index, item) -> BarChartDataEntry in
            // x is index, y is the count
            BarChartDataEntry(x: Double(index), y: Double(item.1))
        }
        
        let set = BarChartDataSet(entries: entries, label: "Weekday Distribution")
        // Use a color template or define your custom colors
        set.colors = ChartColorTemplates.material()
        
        // Set a number formatter so values display as whole numbers
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        set.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        set.drawValuesEnabled = true
        
        let chartData = BarChartData(dataSet: set)
        chartData.barWidth = 0.4
        
        uiView.data = chartData
        
        // Set x-axis labels (the weekdays)
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { $0.0 })
        uiView.xAxis.labelCount = data.count
        
        uiView.notifyDataSetChanged()
    }
}
