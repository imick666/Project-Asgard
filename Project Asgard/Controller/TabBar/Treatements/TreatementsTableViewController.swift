//
//  TreatementsTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 10/12/2020.
//

import UIKit
import CoreData

class TreatementsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    // MARK: - Properties
    
    private var frc: NSFetchedResultsController<Treatement>!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrc()
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        let request: NSFetchRequest<Treatement> = Treatement.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "toDog.name", ascending: true),
            NSSortDescriptor(key: "toPuppy", ascending: true),
            NSSortDescriptor(key: "startDate", ascending: true)
        ]
        
        var predicate: NSPredicate? {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                return NSPredicate(format: "toDog != nil")
            case 1:
                return NSPredicate(format: "toPuppy != nil")
            default:
                return nil
            }
        }
        request.predicate = predicate
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        var sectionNameKeyPath: String? {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                return "toDog.name"
            case 1:
                return "toPuppy.name"
            default:
                return nil
            }
        }
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath , cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Failed to load FetchedResultController")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControllerHasChanged(_ sender: Any) {
        setupFrc()
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frc.sections, !sections.isEmpty else { return 1 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections, !sections.isEmpty else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections, !sections.isEmpty else { return nil }
        return sections[section].name == "" ? "No name" : sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let treatement = frc.sections?[indexPath.section].objects?[indexPath.row] as? Treatement
        
        cell.textLabel?.text = treatement?.name?.capitalized
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
}

extension TreatementsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
