//
//  CreatePuupyViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 02/12/2020.
//

import UIKit

protocol CreatePuppyDelegate {
    func createPuppy(named name: String?, _ affix: String?, sex: Int16, color: String?, image: Data?)
}

class CreatePuppyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var affixTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var dogColorTextField: UITextField!
    @IBOutlet weak var lofNumberTextField: UITextField!
    @IBOutlet weak var chipNumberTextField: UITextField!
    @IBOutlet weak var pitcureImageView: UIImageView!
    
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: CreatePuppyDelegate?
    private let pickerView = PickerViewManager()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateResetButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        pitcureImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Methodes
    
    @objc
    private func selectImage() {
        
    }
    
    private func setupView() {
        resetImageButton.roundFilled(wih: .gray)
        doneButton.roundFilled(wih: .green)
        cancelButton.roundFilled(wih: .red)
        pitcureImageView.rounded(nil)
        pitcureImageView.dogImage(from: nil)
        
    }
    
    private func updateResetButton() {
        resetImageButton.isHidden = !pitcureImageView.imageHasChanged
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetButton(_ sender: Any) {
        pitcureImageView.resetImage()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        let name = nameTextField.text.orNil
        let affix = affixTextField.text.orNil
        let sex = Int16(sexSegmentedControl.selectedSegmentIndex)
        let dogColor = dogColorTextField.text.orNil
        let image = pitcureImageView.image?.jpegData(compressionQuality: 0.8)
        
        delegate?.createPuppy(named: name, affix, sex: sex, color: dogColor, image: image)
    }
}
