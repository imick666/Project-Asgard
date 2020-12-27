//
//  XAxisFormatter.swift
//  Project Asgard
//
//  Created by mickael ruzel on 20/12/2020.
//

import UIKit
import Charts

class ChartXAxisFormatter: IAxisValueFormatter {
    fileprivate var dateFormatter = DateFormatter()
    fileprivate var referenceTimeInterval: TimeInterval?
    
    init(referenceTimeInterval: TimeInterval) {
        self.referenceTimeInterval = referenceTimeInterval
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.locale = Locale.current
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let refTimeInterval = referenceTimeInterval else { return "" }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + refTimeInterval)
        return dateFormatter.string(from: date)
    }
}

class ChartValueFormatter: IValueFormatter {
    private var formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {

        return formatter.string(for: value) ?? ""
    }
    
    
}
