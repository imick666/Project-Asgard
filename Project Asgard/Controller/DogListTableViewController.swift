//
//  DogListTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class DogListTableViewController: UITableViewController {
    
    private var coreData: CoreDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreData()
        setupTableView()
    }

    // MARK: - Methodes
    
    private func setupCoreData() {
        guard let coreDataStack = ((UIApplication.shared.delegate) as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(coreDataStack)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: Constants.Cells.dogMenuCellNib, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.dogMenuCellID)
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreData?.allDogs.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        cell.dog = coreData?.allDogs[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = {
            let label = UILabel()
            label.text = "No dogs to show... Sorry"
            label.numberOfLines = 0
            label.textColor = .gray
            label.textAlignment = .center
            return label
        }()
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreData?.allDogs.count == 0 ? 70 : 0
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let dog = coreData?.allDogs[indexPath.row] else { return }
            coreData?.deteObject(dog)
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesID.createDog {
            guard let destination = segue.destination as? CreateDogViewController else { return }
            destination.delegate = self
        }
    }


}

extension DogListTableViewController: CreateDogDelegate {
    
    func createDog(named name: String, _ affix: String, birthThe date: Date, lofNumber: String?, chipNumber: String?, picture: Data?) {
        
        coreData?.createDog(named: name, affix, birthThe: date, lofNumber: lofNumber, chipNumber: chipNumber, pitcure: picture)
        
        tableView.reloadData()
    }
    
    
}
