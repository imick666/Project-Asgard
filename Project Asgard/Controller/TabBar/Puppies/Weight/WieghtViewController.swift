//
//  WieghtViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 20/12/2020.
//

import UIKit
import Charts

struct Wieght {
    let date: Date
    let wieght: Double
}

class WieghtViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var chartView: LineChartView!
    
    // MARK: - Properties
    
    var numbers = [
        Wieght(date: Date(timeIntervalSinceNow: -604800), wieght: 0.200),
        Wieght(date: Date(timeIntervalSinceNow: -518400), wieght: 0.250),
        Wieght(date: Date(), wieght: 1),
        Wieght(date: Date(timeIntervalSinceNow: 86400), wieght: 1.5),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 2), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 3), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 4), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 5), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 6), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 7), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 8), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 9), wieght: 2),
        Wieght(date: Date(timeIntervalSinceNow: 86400 * 10), wieght: 2)
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        updateGraph()
        
        
    }
    
    // MARK: - Methodes
    
    private func updateGraph() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale.current
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (numbers.map( { $0.date.timeIntervalSince1970 })).min() {
            referenceTimeInterval = minTimeInterval
        }
                
        let xValueNumbersFormatter = ChartXAxisFormatter(dateFormatter: formatter, referenceTimeInterval: referenceTimeInterval)
        
        var lineChartEntry = [ChartDataEntry]()
        
        for object in numbers {
            let timeIntervale = object.date.timeIntervalSince1970
            let xValue = (timeIntervale - referenceTimeInterval) / (3600 * 24)
            let yValue = object.wieght
            
            let entry = ChartDataEntry(x: xValue, y: yValue)
            lineChartEntry.append(entry)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "")
        line1.colors = [NSUIColor.blue]
        line1.drawCircleHoleEnabled = false
        line1.circleRadius = 7
        line1.valueFont = NSUIFont.systemFont(ofSize: 12)
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        chartView.data = data
        chartView.xAxis.valueFormatter = xValueNumbersFormatter
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.leftAxis.enabled = false
        
        
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        
        chartView.setVisibleXRangeMaximum(7)
        chartView.moveViewToX(chartView.chartXMax)
        chartView.minOffset = 16
        
    }

    // MARK: - Actions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        
    }
    

}
