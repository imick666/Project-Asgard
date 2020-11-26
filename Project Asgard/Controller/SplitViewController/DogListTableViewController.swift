//
//  DogListTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class DogListTableViewController: UITableViewController {
    
    private var allDogs: [Dog] {
        return mySplitViewController.coreData?.allDogs ?? [Dog]()
    }
    
    private var mySplitViewController: SplitViewController {
        guard let split = splitViewController as? SplitViewController else {
            fatalError("failed to load splitView Controller")
        }
        return split
    }
    
    private var detailView: DetailDogViewController? {
        guard let splitView = splitViewController as? SplitViewController else { return nil }
        return splitView.detailView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Methodes
    
    private func setupTableView() {
        let nib = UINib(nibName: Constants.Cells.dogMenuCellNib, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Constants.Cells.dogMenuCellID)
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.dogMenuCellID, for: indexPath) as? DogMenuCell else { return UITableViewCell() }
        
        cell.dog = allDogs[indexPath.row]
        
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
        return allDogs.count == 0 ? 70 : 0
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mySplitViewController.coreData?.deteObject(allDogs[indexPath.row])
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailView?.selectedDog = allDogs[indexPath.row]
        splitViewController?.showDetailViewController(detailView!, sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesID.createDog {
            guard let destination = segue.destination as? CreateDogViewController else { return }
            destination.delegate = mySplitViewController
        }
    }
}
