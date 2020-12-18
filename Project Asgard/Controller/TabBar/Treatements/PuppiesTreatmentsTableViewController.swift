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
    
    private var fetchedResultController: NSFetchedResultsController<Treatement>!
    private var coreData: CoreDataManager!
    var selectedLitter: DogLitter!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dogName = selectedLitter.dog!.name.orNc.capitalized
        let date = selectedLitter.date!.ddMMYY
        title = "\(dogName) - \(date)"
        tableView.tableFooterView = UIView()
        setupCoreData()
        setupFrc()

    }
    
    // MARK: - Methodes
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            fatalError("Failed to load CoreData")
        }
        coreData = CoreDataManager(stack)
    }
    
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
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
        } catch {
            fatalError("Failed to load entities")
        }
    }
    
    private func showTreatmentDetail(_ treatment: Treatement) {
        let detailTreatelementVC = DetailTreatementViewController()
        detailTreatelementVC.treatement = treatment
        detailTreatelementVC.preferredContentSize.height = view.bounds.height * 0.4
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.setTitle(treatment.name!.capitalized, font: UIFont.systemFont(ofSize: 25, weight: .semibold), titleColor: nil)
        actionSheet.setContentViewController(detailTreatelementVC)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.confirmDeleteAction { (canceled) in
                switch canceled {
                case true:
                    self.present(actionSheet, animated: true, completion: nil)
                case false:
                    self.coreData.deleteObject(treatment)
                }
            }
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        actionSheet.addAction(okAction)
        actionSheet.addAction(deleteAction)
        
        present(actionSheet, animated: true, completion: nil)
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
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let treatment = fetchedResultController?.object(at: indexPath) else { return }
        
        showTreatmentDetail(treatment)
    }
}

extension PuppiesTreatmentsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
