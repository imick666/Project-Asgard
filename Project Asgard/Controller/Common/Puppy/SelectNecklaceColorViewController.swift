//
//  SelectNecklaceColorViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 15/12/2020.
//

import UIKit

protocol SelectNecklaceColorDelegate {
    func didSelectNecklaceColor(_ color: UIColor?)
}

class SelectNecklaceColorViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var colorButtons: [UIButton]!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    private var selectedColor: UIColor?
    private var selectedTag: Int?
    var delegate: SelectNecklaceColorDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    // MARK: -  Methodes
    
    private func setupButtons() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
        
        colorButtons.forEach({ $0.roundFilled(wih: .gray) })
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectColor(_ sender: UIButton) {
        selectedTag = sender.tag
        selectedColor = sender.backgroundColor
        colorButtons.forEach { (button) in
            if button.tag == selectedTag {
                button.roundFilled(wih: .blue)
            } else {
                button.roundFilled(wih: .gray)
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard selectedColor != nil else { return }
        let color = selectedColor == UIColor.clear ? nil : selectedColor
        
        delegate?.didSelectNecklaceColor(color)
        
        dismiss(animated: true, completion: nil)
    }
    
}
