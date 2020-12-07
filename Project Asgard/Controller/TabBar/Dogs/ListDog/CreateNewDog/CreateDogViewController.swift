//
//  CreateDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class CreateDogViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var affixTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var lofTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    private let imagePicker = PickerViewManager()
    private var coreData: CoreDataManager?
    var dog: Dog?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextFields()
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
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        affixTextField.delegate = self
        lofTextField.delegate = self
        chipTextField.delegate = self
    }
    
    private func sendNotifcation() {
        let noticationCenter = NotificationCenter.default
        noticationCenter.post(name: .changeDog, object: nil)
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
        
        coreData?.createDog(named: name, affix, sex: sex, birthThe: birthDate, lofNumber: lofNumber, chipNumber: chipNumber, pitcure: image)
        
        dismiss(animated: true) {
            self.sendNotifcation()
        }
    }
    
}

extension CreateDogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
