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
    
    private var allPuppies: Bool {
        return puppies.count == 0
    }
    
    var puppies = [Puppy]()
    
    private var frc: NSFetchedResultsController<Puppy>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFrc()
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        let request: NSFetchRequest<Puppy> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "dogLitter.dog.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(format: "sold == %@", NSNumber(booleanLiteral: false))
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch allPuppies {
        case true:
            return frc?.sections?.count ?? 0
        case false:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch allPuppies {
        case true:
            return frc?.sections?[section].name.capitalized
        case false:
            return nil
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch allPuppies {
        case true:
            return frc?.sections?[section].objects?.count ?? 0
        case false:
            return puppies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var puppy: Puppy {
            switch allPuppies {
            case true:
                return frc?.sections?[indexPath.section].objects?[indexPath.row] as! Puppy
            case false:
                return puppies[indexPath.row]
            }
        }
        
        guard let puppySex = DogSex(rawValue: puppy.sex)?.description.capitalized,
              let motherName = puppy.dogLitter?.dog?.name?.capitalized,
              let litterDate = puppy.dogLitter?.date?.ddMMYY else { return UITableViewCell()}
        
        cell.textLabel?.text = "\(String(describing: puppySex)) - \(String(describing: motherName)) - \(String(describing: litterDate))"
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var puppy: Puppy {
            switch allPuppies {
            case true:
                return frc?.sections?[indexPath.section].objects?[indexPath.row] as! Puppy
            case false :
                return puppies[indexPath.row]
            }
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
