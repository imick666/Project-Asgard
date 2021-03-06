//
//  CreateWeightViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 21/12/2020.
//

import UIKit

protocol CreateWeightDelegate {
    
    func didCreateWeight(date: Date, weight: Double)
    
}

class CreateWeightViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: CreateWeightDelegate?
    var minDate: Date?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Methodes
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
        weightTextField.delegate = self
        weightTextField.addDoneToKeayboard()
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
    }
    
    // MARK: - Actions

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        let date = datePicker.date
        guard let text = weightTextField.text, let weight = Double(text) else { return }
        
        delegate?.didCreateWeight(date: date, weight: weight)
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateWeightViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "." || string == ",") && (textField.text!.contains(".") || textField.text!.contains(",")) {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.first == "."  {
            textField.text = "0."
        } else if textField.text?.first == "," {
            textField.text = "0,"
        }
        
        guard let text = textField.text, let number = Double(text) else { return }
        if number < 0 || number > 110 {
            showAlert(title: "Error", message: "You must enter a weight between 0 and 110 Kg")
            textField.text = nil
        }
    }
    
}
