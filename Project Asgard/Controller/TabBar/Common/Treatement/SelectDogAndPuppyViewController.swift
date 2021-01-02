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
        setupFrc()
        setupCoreData()
        setupView()
        setupTableView()
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: setupFrcForDog()
        case 1: setupFrcForPuppy()
        default: return
        }
        
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities")
        }
    }
    
    private func setupFrcForPuppy() {
        let request: NSFetchRequest<NSFetchRequestResult> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "litter.dog.name", ascending: true),
            NSSortDescriptor(key: "litter.date", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        request.predicate = NSPredicate(format: "sold == %@", NSNumber(booleanLiteral: false))
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else {
            return
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "litter.dog.name", cacheName: nil)
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
        setupFrc()
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
        guard let sections = fetchedResultController.sections, !sections.isEmpty else { return 1 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections, !sections.isEmpty else { return 0}
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultController.sections, !sections.isEmpty else { return nil }
        return sections[section].name
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var pets: String {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return "dogs"
            case 1: return "puppies"
            default: return ""
            }
        }
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Please add some \(pets) before to add their treatments"
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let objects = fetchedResultController.fetchedObjects ?? []
        return objects.isEmpty ? tableView.frame.height : 0
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
