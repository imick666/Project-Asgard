//
//  PuppiesListTableViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 06/12/2020.
//

import UIKit

class PuppiesListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var puppies = [Puppy]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return puppies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let puppySex = DogSex(rawValue: puppies[indexPath.row].sex)?.description
        
        cell.textLabel?.text = puppySex
        
        return cell
    }

}
