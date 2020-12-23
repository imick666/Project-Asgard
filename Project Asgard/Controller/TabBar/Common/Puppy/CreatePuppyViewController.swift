//
//  CreatePuupyViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 02/12/2020.
//

import UIKit

protocol CreatePuppyDelegate {
    func createPuppy(named name: String?, _ affix: String?, sex: Int16, color: String?, image: Data?, necklaceColor: String?)
}

class CreatePuppyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var controllerNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var affixTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var puppyColorTextField: UITextField!
    @IBOutlet weak var lofNumberTextField: UITextField!
    @IBOutlet weak var chipNumberTextField: UITextField!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var isSoldSwitch: UISwitch!
    @IBOutlet weak var necklaceColorButton: UIButton!
    @IBOutlet weak var isSoldRow: UIStackView!
    
    @IBOutlet weak var resetImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: CreatePuppyDelegate?
    private let pickerView = PickerViewManager()
    private var coreData: CoreDataManager?
    private var necklaceColor: UIColor? {
        didSet {
            necklaceColorButton.backgroundColor = necklaceColor
            necklaceColorButton.setTitle(necklaceColor == nil ? "None" : nil, for: .normal)
        }
    }
    var puppyToModify: Puppy?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupView()
        setupContent()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        pictureImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Methodes
    
    @objc
    private func selectImage() {
        pickerView.presentAlert(from: self)
        pickerView.completionHandler = { (image) in
            self.pictureImageView.image = image
            self.updateResetButton()
        }
    }
    
    private func setupView() {
        resetImageButton.roundFilled(wih: .gray)
        doneButton.roundFilled(wih: .green)
        cancelButton.roundFilled(wih: .red)
        pictureImageView.rounded(nil)
        necklaceColorButton.roundFilled(wih: .gray)
        necklaceColorButton.setTitle("None", for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.roundFilled(wih: nil)
        
        setupTextFields()
        updateResetButton()
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        nameTextField.addDoneToKeayboard()
        affixTextField.delegate = self
        affixTextField.addDoneToKeayboard()
        puppyColorTextField.delegate = self
        puppyColorTextField.addDoneToKeayboard()
        lofNumberTextField.delegate = self
        lofNumberTextField.addDoneToKeayboard()
        chipNumberTextField.delegate = self
        chipNumberTextField.addDoneToKeayboard()
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            fatalError("Failed to load CoreDataStack")
        }
        coreData = CoreDataManager(stack)
    }
    
    private func setupContent() {
        deleteButton.isHidden = true
        isSoldRow.isHidden = true
        
        guard let puppy = puppyToModify else { return }
        controllerNameLabel.text = "Modify existing puppy"
        nameTextField.text = puppy.name
        affixTextField.text = puppy.affix
        lofNumberTextField.text = puppy.lofNumber
        chipNumberTextField.text = puppy.chipNumber
        pictureImageView.setDogImage(from: puppy.image)
        puppyColorTextField.text = puppy.puppyColor
        sexSegmentedControl.selectedSegmentIndex = Int(puppy.sex)
        isSoldSwitch.setOn(puppy.sold!.boolValue, animated: true)
        necklaceColor = UIColor(fromHex: puppy.necklaceColor)
        necklaceColorButton.setTitle(necklaceColor == nil ? "None" : nil, for: .normal)
        deleteButton.isHidden = false
        isSoldRow.isHidden = false
    }
    
    private func updateResetButton() {
        resetImageButton.isHidden = !pictureImageView.imageHasChanged
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetButton(_ sender: Any) {
        pictureImageView.resetImage()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSelectNecklaceColorButton(_ sender: UIButton) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.necklaceColor) as? SelectNecklaceColorViewController else { return }
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        confirmDeleteAction { (cancelled) in
            switch cancelled {
            case true:
                return
            case false:
                self.coreData?.deleteObject(self.puppyToModify!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let affix = affixTextField.text.orNil else {
            showAlert(title: "Error", message: "You must add an Affix")
            return
        }
        let name = nameTextField.text.orNil
        let sex = Int16(sexSegmentedControl.selectedSegmentIndex)
        let puppyColor = puppyColorTextField.text.orNil
        let lofNumber = lofNumberTextField.text.orNil
        let chipNumber = chipNumberTextField.text.orNil
        let image = pictureImageView.imageOrNil?.jpegData(compressionQuality: 0.8)
        let necklaceColor = self.necklaceColor?.toHex
        let sold = NSNumber(booleanLiteral: isSoldSwitch.isOn)
        
        if puppyToModify != nil {
            coreData?.update(puppy: puppyToModify!, value: [
                (name, "name"),
                (affix, "affix"),
                (sex, "sex"),
                (puppyColor, "puppyColor"),
                (lofNumber, "lofNumber"),
                (chipNumber, "chipNumber"),
                (image, "image"),
                (necklaceColor, "necklaceColor"),
                (sold, "sold")
            ])
        } else {
            delegate?.createPuppy(named: name, affix, sex: sex, color: puppyColor, image: image, necklaceColor: necklaceColor)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePuppyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.isFirstResponder { affixTextField.becomeFirstResponder() }
        else if affixTextField.isFirstResponder { puppyColorTextField.becomeFirstResponder() }
        else if puppyColorTextField.isFirstResponder { lofNumberTextField.becomeFirstResponder() }
        else if lofNumberTextField.isFirstResponder { chipNumberTextField.becomeFirstResponder() }
        else if chipNumberTextField.isFirstResponder { textField.resignFirstResponder() }
        return true
    }
}

extension CreatePuppyViewController: SelectNecklaceColorDelegate {
    func didSelectNecklaceColor(_ color: UIColor?) {
        necklaceColor = color
    }
}
