
import SwiftUI
import DGCharts

struct LineChartViewWrapper: UIViewRepresentable {
    /// Daily trend data (e.g., number of mood entries for each day in the selected range)
    var data: [Double]
    /// Optional labels for the x-axis (e.g., formatted dates)
    var labels: [String]? = nil
    
    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.leftAxis.axisMinimum = 0
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawGridLinesEnabled = false
        chart.legend.enabled = false
        chart.animate(xAxisDuration: 1.0)
        return chart
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let entries = data.enumerated().map { index, value in
            ChartDataEntry(x: Double(index), y: value)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Daily Trend")
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.circleColors = [NSUIColor.systemBlue]
        dataSet.lineWidth = 2
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.mode = .cubicBezier
        
        // Format values to show as whole numbers (if displayed)
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        dataSet.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        dataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(dataSet: dataSet)
        uiView.data = chartData
        
        if let labels = labels {
            uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
            uiView.xAxis.granularity = 1
        }
        
        uiView.notifyDataSetChanged()
    }
}
