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
    
    @IBOutlet weak var controllerNameLabel: UILabel!
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
    private var coreDataStack: CoreDataStack?
    var puppy: Puppy?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if puppy != nil {
            setupContent()
        }
        setupCoreData()
        setupView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        pitcureImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Methodes
    
    @objc
    private func selectImage() {
        pickerView.presentAlert(from: self)
        pickerView.completionHandler = { (image) in
            self.pitcureImageView.image = image
            self.updateResetButton()
        }
    }
    
    private func setupView() {
        resetImageButton.roundFilled(wih: .gray)
        doneButton.roundFilled(wih: .green)
        cancelButton.roundFilled(wih: .red)
        pitcureImageView.rounded(nil)
        pitcureImageView.dogImage(from: nil)
        
        updateResetButton()
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            fatalError("Failed to load CoreDataStack")
        }
        coreDataStack = stack
    }
    
    private func setupContent() {
        controllerNameLabel.text = "Modify existing puppy"
        nameTextField.text = puppy?.name
        affixTextField.text = puppy?.affix
        lofNumberTextField.text = puppy?.lofNumber
        chipNumberTextField.text = puppy?.chipNumber
        pitcureImageView.dogImage(from: puppy!.image)
        dogColorTextField.text = puppy?.puppyColor
        sexSegmentedControl.selectedSegmentIndex = Int(puppy!.sex)
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
        let puppyColor = dogColorTextField.text.orNil
        let lofNumber = lofNumberTextField.text.orNil
        let chipNumber = chipNumberTextField.text.orNil
        let image = pitcureImageView.imageOrNil?.jpegData(compressionQuality: 0.8)
        
        if puppy != nil {
            puppy?.name = name
            puppy?.affix = affix
            puppy?.sex = sex
            puppy?.lofNumber = lofNumber
            puppy?.chipNumber = chipNumber
            puppy?.puppyColor = puppyColor
            puppy?.image = image
            
            coreDataStack?.saveContext()
        } else {
            delegate?.createPuppy(named: name, affix, sex: sex, color: puppyColor, image: image)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
