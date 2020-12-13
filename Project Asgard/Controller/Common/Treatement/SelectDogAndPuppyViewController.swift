//
//  SelectDogAndPuppyViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 13/12/2020.
//

import UIKit
import CoreData

protocol SelectDogAndPuppyDelegate {
    func didSelectDogsAndPuppies(_ allObjects: [NSObject])
}

class SelectDogAndPuppyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    // Private
    private var coreData: CoreDataManager!
    private var allObjects: [NSObject] {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return coreData.allDogs
        case 1:
            return coreData.allPuppies
        default:
            return []
        }
    }
    
    // Public
    var delegate: SelectDogAndPuppyDelegate?
    var selectedObjects = [NSObject]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupView()
        setupTableView()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methodes
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: Constants.Cells.dogMenuCellNib, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.dogMenuCellID)
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
    }
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
    }
    
    // MARK: - Actions

    @IBAction func segmentedValueHasChange(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        delegate?.didSelectDogsAndPuppies(selectedObjects)
        dismiss(animated: true, completion: nil)
    }
}

extension SelectDogAndPuppyViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        if let puppy = allObjects[indexPath.row] as? Puppy {
            cell.puppy = puppy
            selectedObjects.contains(puppy) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        } else if let dog = allObjects[indexPath.row] as? Dog {
            cell.dog = dog
            selectedObjects.contains(dog) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedObjects.contains(allObjects[indexPath.row]) {
            selectedObjects.removeAll(where: { $0 == allObjects[indexPath.row] })
        } else {
            selectedObjects.append(allObjects[indexPath.row])
        }
        
        tableView.reloadData()
    }
}
