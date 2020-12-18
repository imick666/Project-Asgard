//
//  DogListTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit
import CoreData

class DogListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sementedController: UISegmentedControl!
    
    // MARK: - Properties

    private var fetchedResultController: NSFetchedResultsController<Dog>?
    
    // MARK: - Vew Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFetchedResultControler()
    }

    // MARK: - Methodes
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: Constants.Cells.dogMenuCellNib, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.dogMenuCellID)
        tableView.tableFooterView = UIView()
    }
    
    private func setupFetchedResultControler() {
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        var sortDescriptor: [NSSortDescriptor] {
            switch sementedController.selectedSegmentIndex {
            case 0:
                return [NSSortDescriptor(key: "name", ascending: true)]
            case 1:
                return [NSSortDescriptor(key: "birthDate", ascending: true)]
            default:
                fatalError()
            }
        }
        request.sortDescriptors = sortDescriptor
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
        } catch {
            fatalError("Failed to fetche entities")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController?.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        cell.dog = fetchedResultController?.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No dogs to show... Sorry"
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
        return fetchedResultController?.fetchedObjects?.count == 0 ? finalHeight : 0
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SeguesID.detailDog, sender: fetchedResultController?.object(at: indexPath))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesID.detailDog {
            guard let destination = segue.destination as? PetDetailsViewController else { return }
            destination.selectedDog = sender as? Dog
        }
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControllerValueHasChanged(_ sender: Any) {
        setupFetchedResultControler()
    }
    
}

extension DogListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
