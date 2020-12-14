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
    private var coreData: CoreDataManager!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrc()
        setupCoreData()
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        let request: NSFetchRequest<Treatement> = Treatement.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "toDog.name", ascending: true),
            NSSortDescriptor(key: "toPuppy.name", ascending: true),
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
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Failed to load FetchedResultController")
        }
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
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
        return sections[section].name == "" ? "No name" : sections[section].name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let treatement = frc.sections?[indexPath.section].objects?[indexPath.row] as? Treatement
        
        cell.textLabel?.text = treatement?.name?.capitalized
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let object = frc.sections?[indexPath.section].objects?[indexPath.row] as? Treatement,
              let name = object.name else { return }
        
        let detailTreatelementVC = DetailTreatementViewController()
        detailTreatelementVC.treatement = object
        detailTreatelementVC.preferredContentSize.height = view.bounds.height * 0.4
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.setTitle(name, font: UIFont.systemFont(ofSize: 25, weight: .semibold), titleColor: nil)
        actionSheet.setContentViewController(detailTreatelementVC)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.confirmDeleteAction { (canceled) in
                switch canceled {
                case true:
                    self.present(actionSheet, animated: true, completion: nil)
                case false:
                    self.coreData.deleteObject(object)
                }
            }
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        actionSheet.addAction(okAction)
        actionSheet.addAction(deleteAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension TreatementsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
