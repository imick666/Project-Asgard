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
    
    // MARK: - Properties
    
    private let imagePicker = PickerViewManager()
    private var coreDataStack: CoreDataStack!
    private var coreData: CoreDataManager!
    var dog: Dog?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dog != nil {
            setupContent()
        }
        setupView()
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
        coreDataStack = stack
        coreData = CoreDataManager(coreDataStack)
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
        affixTextField.delegate = self
        lofTextField.delegate = self
        chipTextField.delegate = self
        dogColorTextField.delegate = self
    }
    
    private func setupContent() {
        controllerNameLabel.text = "Modify existing dog"
        nameTextField.text = dog?.name
        affixTextField.text = dog?.affix
        chipTextField.text = dog?.chipNumber
        lofTextField.text = dog?.lofNumber
        birthDatePicker.setDate(dog!.birthDate!, animated: true)
        dogImageView.setDogImage(from: dog?.image)
        sexSegmentedControl.selectedSegmentIndex = Int(dog!.sex)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetImageButton(_ sender: Any) {
        dogImageView.image = UIImage(named: "DogPlaceHolder")
        resetImageButton.isHidden = !dogImageView.imageHasChanged
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let name = nameTextField.text.orNil, let affix = affixTextField.text.orNil else { return }
        let birthDate = birthDatePicker.date
        let lofNumber = lofTextField.text.orNil
        let chipNumber = chipTextField.text.orNil
        let image = dogImageView.imageOrNil?.jpegData(compressionQuality: 0.8)
        let sex = Int16(sexSegmentedControl.selectedSegmentIndex)
        
        if dog == nil {
            coreData?.createDog(named: name, affix, sex: sex, birthThe: birthDate, lofNumber: lofNumber, chipNumber: chipNumber, pitcure: image)
        } else {
            dog?.name = name
            dog?.affix = affix
            dog?.birthDate = birthDate
            dog?.lofNumber = lofNumber
            dog?.chipNumber = chipNumber
            dog?.image = image
            dog?.sex = sex
            
            coreDataStack.saveContext()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateDogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
