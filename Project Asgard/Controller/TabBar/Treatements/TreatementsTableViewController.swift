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
    
    private var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    private var coreData: CoreDataManager!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFrc()
    }
    
    // MARK: - Methodes

    private func setupFrc() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else {
            return
        }
        
        switch segmentedController.selectedSegmentIndex {
        case 0: setupFrcDog(context: context)
        case 1: setupFrcPuppy(context: context)
        default: return
        }
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities")
        }
        
        tableView.reloadData()
    }
    
    private func setupFrcDog(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = Treatement.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "toDog.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(format: "toDog != nil && endDate > %@", Date(timeIntervalSinceNow: -86400) as CVarArg)
                
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "toDog.name", cacheName: nil)
    }
    
    private func setupFrcPuppy(context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = DogLitter.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "dog.name", ascending: true),
            NSSortDescriptor(key: "date", ascending: false)
        ]
        
        request.predicate = NSPredicate(format: "SUBQUERY(puppies, $puppy, SOME $puppy.treatements != nil && SOME $puppy.treatements.endDate > %@).@count != 0", Date(timeIntervalSinceNow: -86400) as CVarArg)
    
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "dog.name", cacheName: nil)
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
    }
    
    private func showLitter(_ litter: DogLitter) {
        let treatementForLitter = PuppiesTreatmentsTableViewController()
        treatementForLitter.selectedLitter = litter
        
        show(treatementForLitter, sender: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControllerHasChanged(_ sender: Any) {
        setupFrc()
    }
    
    @IBAction func didTapAddTreatementsButtons(_ sender: Any) {
        guard let createTreatmentsVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createTreatement) as? CreateTreatementViewController else { return }
        
        createTreatmentsVC.delegate = self
        present(createTreatmentsVC, animated: true) {
            print("done")
        }
    }
    
    
    // MARK: - Table view data source
    
    // Section

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultController?.sections, !sections.isEmpty else { return 1 }
        return sections.count
    }

    // Header
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultController?.sections, !sections.isEmpty else { return nil }
        return sections[section].name.capitalized
    }
    
    // Row
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections, !sections.isEmpty else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let treatement = fetchedResultController?.object(at: indexPath) as? Treatement
        let litter = fetchedResultController?.object(at: indexPath) as? DogLitter
        switch segmentedController.selectedSegmentIndex {
        case 0: cell.textLabel?.text = treatement?.name?.capitalized
        case 1: cell.textLabel?.text = litter?.date?.ddMMYY
        default: cell.textLabel?.text = ""
        }

        return cell
    }
    
    // Footer
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = """
            All your pets are good!!
            """
        label.textColor = .gray
        label.textAlignment = .center
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let navBarMaxY = navigationController?.navigationBar.frame.maxY ?? 0
        let tabBarMinY = tabBarController?.tabBar.frame.minY ?? 0
        let finalHeight = tabBarMinY - navBarMaxY
        
        return fetchedResultController?.fetchedObjects?.count == 0 ? finalHeight : 0
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        switch segmentedController.selectedSegmentIndex {
        case 0:
            guard let treatment = fetchedResultController?.object(at: indexPath) as? Treatement else { return }
            showTreatmentDeatil(for: treatment, coreData: coreData)
        case 1:
            guard let litter = fetchedResultController?.object(at: indexPath) as? DogLitter else { return }
            showLitter(litter)
        default: return
        }
    }
}

extension TreatementsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension TreatementsTableViewController: CreateTreatmentDelegate {
    func treatementsDidCreate() {
        setupFrc()
    }
}
