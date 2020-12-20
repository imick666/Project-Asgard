//
//  XAxisFormatter.swift
//  Project Asgard
//
//  Created by mickael ruzel on 20/12/2020.
//

import UIKit
import Charts

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    init(dateFormatter: DateFormatter, referenceTimeInterval: TimeInterval) {
        self.dateFormatter = dateFormatter
        self.referenceTimeInterval = referenceTimeInterval
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
              let refTimeInterval = referenceTimeInterval else { return "" }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + refTimeInterval)
        return dateFormatter.string(from: date)
    }
}
