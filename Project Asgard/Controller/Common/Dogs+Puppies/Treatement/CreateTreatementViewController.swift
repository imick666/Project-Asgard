//
//  CreateTreatementViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 27/11/2020.
//

import UIKit

class CreateTreatementViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    var forObject: NSObject!
    
    private var coreData: CoreDataManager?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupView()
        addDoneToKeyboard()
        nameTextField.delegate = self

    }
    
    // MARK: - Methodes
    
    @objc
    private func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    private func addDoneToKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let felxi = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        let items = [felxi, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        noteTextView.inputAccessoryView = doneToolbar
        
    }

    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            return
        }
        coreData = CoreDataManager(stack)
    }
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let name = nameTextField.text else {
            // TODO: add Alert
            // "You must enter a name"
            return
        }
        let note = noteTextView.text.orNil
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
              
        coreData?.createTreatement(named: name, startDate: startDate, endDate: endDate, note: note, to: forObject)
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateTreatementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
