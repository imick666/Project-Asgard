//
//  PuppiesListTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 06/12/2020.
//

import UIKit
import CoreData

class PuppiesListTableViewController: UITableViewController {
    
    // MARK: - Properties

    var litterID: DogLitter?
    
    private var frc: NSFetchedResultsController<Puppy>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrc()
        setupView()
    }
    
    // MARK: - Methodes
    
    private func setupView() {
        let nib = UINib(nibName: Constants.Cells.dogMenuCellNib, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.dogMenuCellID)
        tableView.tableFooterView = UIView()
    }
    
    private func setupFrc() {
        let request: NSFetchRequest<Puppy> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        var predicate: NSPredicate {
            switch litterID {
            case .none:
                return NSPredicate(format: "sold == %@", NSNumber(booleanLiteral: false))
            case .some(let id):
                return NSPredicate(format: "dogLitter == %@", id)
            }
        }
        
        request.predicate = predicate
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "dogLitter.dog.name", cacheName: nil)
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
        } catch {
            print("hoho")
        }
    }

    // MARK: - Table view data source
    
    // Header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { return nil }
        return !sections.isEmpty ? sections[section].name : nil
    }
    
    // NumberOfSections / Row
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frc.sections, !sections.isEmpty else { return 1 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections, !sections.isEmpty else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    // Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        var puppy: Puppy? {
            guard let sections = frc.sections, !sections.isEmpty else {
                return nil
            }
            return sections[indexPath.section].objects?[indexPath.row] as? Puppy
        }

        cell.puppy = puppy

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // Footer
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = """
        No puppies to show for the moment...
        Come back at the next litter
        """
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        var finalHeight: CGFloat {
            let minTabBarY = tabBarController?.tabBar.frame.minY ?? 0
            let maxNavBarY = navigationController?.navigationBar.frame.maxY ?? 0
            return (minTabBarY - maxNavBarY)
        }
        
        guard let sections = frc.sections else { return 0 }
        return !sections.isEmpty ? 0 : finalHeight
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var puppy: Puppy? {
            guard let sections = frc.sections, !sections.isEmpty else {
                return nil
            }
            return sections[indexPath.section].objects?[indexPath.row] as? Puppy
        }
        performSegue(withIdentifier: Constants.SeguesID.detailPuppy, sender: puppy)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesID.detailPuppy {
            guard let destination = segue.destination as? DetailPuppyViewController else { return }
            destination.selectedPuppy = sender as? Puppy
        }
    }

}

extension PuppiesListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
