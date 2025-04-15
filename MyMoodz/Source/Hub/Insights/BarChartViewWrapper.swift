//
//  BarChartViewWrapper.swift
//  MyMoodz
//
//  Created by Nagaraj Alagusundaram on 15/4/2025.
//

import DGCharts
import SwiftUI

struct BarChartViewWrapper: UIViewRepresentable {
    var data: [(String, Int)]

    func makeUIView(context: Context) -> BarChartView {
        let chart = BarChartView()
        chart.legend.enabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.axisMinimum = 0
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.granularity = 1
        chart.xAxis.drawGridLinesEnabled = false
        return chart
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        let entries = data.enumerated().map { index, item in
            BarChartDataEntry(x: Double(index), y: Double(item.1))
        }

        let set = BarChartDataSet(entries: entries, label: "Moods per Day")
        set.colors = ChartColorTemplates.material()
        let chartData = BarChartData(dataSet: set)
        chartData.barWidth = 0.4
        chartData.setDrawValues(true)

        uiView.data = chartData
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data.map { $0.0 })
        uiView.xAxis.labelCount = data.count
    }
}
