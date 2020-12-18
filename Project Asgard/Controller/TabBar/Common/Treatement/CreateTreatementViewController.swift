//
//  CreateTreatementViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 27/11/2020.
//

import UIKit

protocol CreateTreatmentDelegate {
    func treatementsDidCreate()
}

class CreateTreatementViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    var objects = [NSObject]()
    var delegate: CreateTreatmentDelegate?
    
    private var coreData: CoreDataManager?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Methodes
    
    private func setupTextFieldAndView() {
        nameTextField.addDoneToKeayboard()
        nameTextField.delegate = self
        noteTextView.addDoneToKeayboard()
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
        setupTextFieldAndView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func selectDogs() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.selectDogAndPuppy) as? SelectDogAndPuppyViewController else { return }
        vc.selectedObjects = objects
        vc.delegate = self
        present(vc, animated: true, completion: nil)
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
              
        objects.forEach { (object) in
            coreData?.createTreatement(named: name, startDate: startDate, endDate: endDate, note: note, to: object)
        }
        
        dismiss(animated: true) {
            self.delegate?.treatementsDidCreate()
        }
        
    }
}

extension CreateTreatementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.isFirstResponder { noteTextView.becomeFirstResponder() }
        return true
    }
}

extension CreateTreatementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        var name: String? {
            if let dog = objects[indexPath.row] as? Dog {
                return dog.name?.capitalized
            } else if let puppy = objects[indexPath.row] as? Puppy {
                return puppy.name?.capitalized
            } else {
                return nil
            }
        }
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Add dog", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(selectDogs), for: .touchUpInside)
        
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
}

extension CreateTreatementViewController: SelectDogAndPuppyDelegate {
    func didSelectDogsAndPuppies(_ allObjects: [NSObject]) {
        objects = allObjects
        tableView.reloadData()
    }
}
