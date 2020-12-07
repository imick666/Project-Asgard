//
//  DetailTreatementViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 27/11/2020.
//

import UIKit

class DetailTreatementViewController: UIViewController {
    
    // MARK: - View Properties
    
    private var startDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private var endDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private var noteTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 17)
        
        return textView
    }()
    
    private var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        return stack
    }()
    
    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        return stack
    }()
    
    // MARK: - Properties
    
    var treatement: Treatement!
        
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContent()
    }
    
    
    // MARK: - Methodes
    
    private func setupContent() {
        startDateLabel.text = """
            Start
            \(String(treatement.startDate!.ddMMYY))
            """
        endDateLabel.text = """
            End
            \(String(treatement.endDate!.ddMMYY))
            """
        noteTextView.text = treatement.note ?? ""
    }

    private func setupViews() {
        hStack.addArrangedSubview(startDateLabel)
        hStack.addArrangedSubview(endDateLabel)
 
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(noteTextView)
        
        view.addSubview(vStack)
        
        vStack.setAnchors(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailling: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
    }
}
