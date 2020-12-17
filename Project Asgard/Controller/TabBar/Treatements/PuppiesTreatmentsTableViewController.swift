//
//  PuppiesTreatmentsTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 17/12/2020.
//

import UIKit
import CoreData

class PuppiesTreatmentsTableViewController: UITableViewController {

    // MARK: - Properties
    
    private var fetchedResultController: NSFetchedResultsController<Treatement>?
    var selectedLitter: DogLitter!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dogName = selectedLitter.dog!.name.orNc.capitalized
        let date = selectedLitter.date!.ddMMYY
        title = "\(dogName) - \(date)"
        setupFrc()

    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        let request: NSFetchRequest<Treatement> = Treatement.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "toPuppy.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
            NSSortDescriptor(key: "startDate", ascending: false)
        ]
        request.predicate = NSPredicate(format: "toPuppy != nil && toPuppy.litter == %@", selectedLitter)
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "toPuppy.name", cacheName: nil)
        
        do {
            try fetchedResultController?.performFetch()
        } catch {
            fatalError("Failed to load entities")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 0
    }
    
    // Header
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultController?.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController?.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = fetchedResultController?.object(at: indexPath).name

        return cell
    }

}
