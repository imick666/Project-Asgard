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
    private var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    // Public
    var delegate: SelectDogAndPuppyDelegate?
    var selectedObjects = [NSObject]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        switch segmentedControl.selectedSegmentIndex {
        case 0: setupFrcForDog()
        case 1: setupFrcForPuppy()
        default: return
        }
        setupCoreData()
        setupView()
        setupTableView()
    }
    
    // MARK: - Methodes
    
    private func setupFrcForPuppy() {
        let request: NSFetchRequest<NSFetchRequestResult> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "dogLitter.dog.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else {
            return
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "dogLitter.dog.name", cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
    
    private func setupFrcForDog() {
        let request: NSFetchRequest<NSFetchRequestResult> = Dog.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true),
        ]
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else {
            return
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
    
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
        switch segmentedControl.selectedSegmentIndex {
        case 0: setupFrcForDog()
        case 1: setupFrcForPuppy()
        default: return
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        if let puppy = fetchedResultController.object(at: indexPath) as? Puppy {
            cell.puppy = puppy
            selectedObjects.contains(puppy) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        } else if let dog = fetchedResultController.object(at: indexPath) as? Dog {
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
        
        if selectedObjects.contains(fetchedResultController.object(at: indexPath) as! NSObject) {
            selectedObjects.removeAll(where: { $0 == fetchedResultController.object(at: indexPath) as! AnyHashable })
        } else {
            selectedObjects.append(fetchedResultController.object(at: indexPath) as! NSObject)
        }
        
        tableView.reloadData()
    }
}
