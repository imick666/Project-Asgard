//
//  CreateDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

protocol CreateDogDelegate {
    
    func createDog()
}

class CreateDogViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var affixTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var lofTextField: UITextField!
    @IBOutlet weak var chipTextField: UITextField!
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    private let imagePicker = PickerViewManager()
    private var imageHasChanged: Bool {
        return dogImageView.image?.pngData() != UIImage(named: "DogPlaceHolder")?.pngData()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextFields()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTapped(_:)))
        dogImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Methodes
    
    @objc
    private func imageViewDidTapped(_ gesture: UITapGestureRecognizer) {
        imagePicker.presentAlert(from: self)
        imagePicker.completionHandler = { (image) in
            self.dogImageView.image = image
            self.resetImageButton.isHidden = !self.imageHasChanged
        }
    }
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
        resetImageButton.roundFilled(wih: .gray)
        dogImageView.rounded(nil)
        resetImageButton.isHidden = !imageHasChanged
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        affixTextField.delegate = self
        lofTextField.delegate = self
        chipTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetImageButton(_ sender: Any) {
        dogImageView.image = UIImage(named: "DogPlaceHolder")
        resetImageButton.isHidden = !imageHasChanged
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        
    }
    
}

extension CreateDogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
