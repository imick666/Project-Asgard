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
    
    var allPuppies = true
    
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
            NSSortDescriptor(key: "name", ascending: true)
        ]
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try frc?.performFetch()
            if allPuppies {
                puppies = frc!.fetchedObjects!
            }
        } catch {
            print("hoho")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puppies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let puppy = puppies[indexPath.row]
        
        guard let puppySex = DogSex(rawValue: puppy.sex)?.description.capitalized,
              let motherName = puppy.dogLitter?.dog?.name?.capitalized,
              let litterDate = puppy.dogLitter?.date?.ddMMYY else { return UITableViewCell()}
        
        cell.textLabel?.text = "\(String(describing: puppySex)) - \(String(describing: motherName)) - \(String(describing: litterDate))"
        
        return cell
    }

}
