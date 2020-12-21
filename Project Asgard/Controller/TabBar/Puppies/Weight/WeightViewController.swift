//
//  WieghtViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 20/12/2020.
//

import UIKit
import Charts

class WeightViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var noWeightLabel: UILabel!
    
    // MARK: - Properties
    
    var weights = [Weight]() {
        didSet {
            noWeightLabel.isHidden = !weights.isEmpty
            chartView.isHidden = weights.isEmpty
            if !weights.isEmpty {
                updateGraph()
                setupChart()
            }
        }
    }
    
    private var puppy: Puppy? {
        return parentView?.selectedPuppy
    }
    
    private var parentView: PetDetailsViewController? {
        return parent as? PetDetailsViewController
    }
    
    private var coreData: CoreDataManager!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCoreData()
        updateGraph()

    }
    
    // MARK: - Methodes
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
    }
    
    private func setupView() {
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        setupChart()
    }
    
    private func setupChart() {
        
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.leftAxis.enabled = false
        
        
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        
        chartView.setVisibleXRangeMaximum(7)
        
        var minTime: TimeInterval = 0
        if let minTI = (weights.map( { $0.date!.timeIntervalSince1970 })).min() {
            minTime = minTI
        }
        var maxTime: TimeInterval = 0
        if let lastTI = (weights.map( { $0.date!.timeIntervalSince1970 })).max() {
            maxTime = lastTI
        }
        chartView.moveViewToX((maxTime - minTime) / (3600 * 24))
        chartView.minOffset = 16
    }
    
    private func updateGraph() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale.current
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (weights.map( { $0.date!.timeIntervalSince1970 })).min() {
            referenceTimeInterval = minTimeInterval
        }
                
        let xValueNumbersFormatter = ChartXAxisFormatter(dateFormatter: formatter, referenceTimeInterval: referenceTimeInterval)
        
        var lineChartEntry = [ChartDataEntry]()
        
        for weight in weights {
            let timeIntervale = weight.date!.timeIntervalSince1970
            let xValue = (timeIntervale - referenceTimeInterval) / (3600 * 24)
            let yValue = weight.weight
            
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
    }

    // MARK: - Actions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let createWeightVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createWeight) as? CreateWeightViewController else {
            return
        }
        
        createWeightVC.delegate = self
        parent?.present(createWeightVC, animated: true, completion: nil)
    }

}

extension WeightViewController: CreateWeightDelegate {
    func didCreateWeight(date: Date, weight: Double) {
        guard let puppy = puppy else { return }
        coreData.createWeight(for: puppy, date: date, weight: weight)
    }
}
