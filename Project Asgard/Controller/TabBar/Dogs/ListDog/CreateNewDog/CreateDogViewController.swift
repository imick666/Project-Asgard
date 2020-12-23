//
//  CreateDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class CreateDogViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var controllerNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var affixTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dogColorTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var lofTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Properties
    
    private let imagePicker = PickerViewManager()
    private var coreData: CoreDataManager!
    var dogToModify: Dog?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContent()
        setupCoreData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTapped(_:)))
        dogImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Methodes
    
    @objc
    private func imageViewDidTapped(_ gesture: UITapGestureRecognizer) {
        imagePicker.presentAlert(from: self)
        imagePicker.completionHandler = { (image) in
            self.dogImageView.image = image
            self.resetImageButton.isHidden = !self.dogImageView.imageHasChanged
        }
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            fatalError("Failed to load CoreData")
        }
        coreData = CoreDataManager(stack)
    }
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
        resetImageButton.roundFilled(wih: .gray)
        dogImageView.rounded(nil)
        resetImageButton.isHidden = !dogImageView.imageHasChanged
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        nameTextField.addDoneToKeayboard()
        affixTextField.delegate = self
        affixTextField.addDoneToKeayboard()
        lofTextField.delegate = self
        lofTextField.addDoneToKeayboard()
        chipTextField.delegate = self
        chipTextField.addDoneToKeayboard()
        dogColorTextField.delegate = self
        dogColorTextField.addDoneToKeayboard()
    }
    
    private func setupContent() {
        deleteButton.isHidden = true
        
        guard let dog = dogToModify else { return }
        controllerNameLabel.text = "Modify existing dog"
        nameTextField.text = dog.name
        affixTextField.text = dog.affix
        chipTextField.text = dog.chipNumber
        lofTextField.text = dog.lofNumber
        birthDatePicker.setDate(dog.birthDate!, animated: true)
        dogImageView.setDogImage(from: dog.image)
        sexSegmentedControl.selectedSegmentIndex = Int(dog.sex)
        deleteButton.isHidden = false
        deleteButton.roundFilled(wih: nil)
        deleteButton.backgroundColor = .red
        deleteButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetImageButton(_ sender: Any) {
        dogImageView.image = UIImage(named: "DogPlaceHolder")
        resetImageButton.isHidden = !dogImageView.imageHasChanged
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        confirmDeleteAction { (cancelled) in
            switch cancelled {
            case true: return
            case false:
                self.coreData.deleteObject(self.dogToModify!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let name = nameTextField.text.orNil, let chipNumber = chipTextField.text.orNil else {
            showAlert(title: "Error", message: "You must enter a name and chip number")
            return
        }
        let birthDate = birthDatePicker.date
        let sex = Int16(sexSegmentedControl.selectedSegmentIndex)
        
        let affix = affixTextField.text.orNil
        let dogColor = dogColorTextField.text.orNil
        let lofNumber = lofTextField.text.orNil
        let image = dogImageView.imageOrNil?.jpegData(compressionQuality: 0.8)
        
        
        if dogToModify != nil {
            coreData.update(dog: dogToModify!, value: [
                (name, "name"),
                (affix, "affix"),
                (dogColor, "dogColor"),
                (birthDate, "birthDate"),
                (lofNumber, "lofNumber"),
                (chipNumber, "chipNumber"),
                (image, "image"),
                (sex, "sex"),
            ])
        } else {

            coreData?.createDog(named: name, affix, sex: sex, dogColor: dogColor, birthThe: birthDate, lofNumber: lofNumber, chipNumber: chipNumber, pitcure: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateDogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.isFirstResponder { affixTextField.becomeFirstResponder() }
        else if affixTextField.isFirstResponder { dogColorTextField.becomeFirstResponder() }
        else if dogColorTextField.isFirstResponder { lofTextField.becomeFirstResponder() }
        else if lofTextField.isFirstResponder { chipTextField.becomeFirstResponder() }
        else if chipTextField.isFirstResponder { textField.resignFirstResponder() }
        return true
    }
}
