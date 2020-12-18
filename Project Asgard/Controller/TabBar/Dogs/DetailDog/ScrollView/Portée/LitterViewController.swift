//
//  PortéeViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 28/11/2020.
//

import UIKit

protocol LitterViewControllerDelegate {
    func litterDidSelect(_ litter: DogLitter)
}

class LitterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var litters = [DogLitter]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: LitterViewControllerDelegate?
    
    private var parentView: PetDetailsViewController {
        guard let vc = parent as? PetDetailsViewController else {
            fatalError("Failed to load parent viewController")
        }
        return vc
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }
    
    // MARK: - Methodes
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func setupView() {
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let createLitterVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createLitter) as? CreateLitterViewController else { return }
        createLitterVC.forDog = parentView.selectedDog
        present(createLitterVC, animated: true, completion: nil)
    }
}

// MARK: - TableView

extension LitterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return litters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = litters[indexPath.row].date?.ddMMYY
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "This dog has no litter for the moment"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return litters.count == 0 ? tableView.bounds.height : 0
    }

    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.litterDidSelect(litters[indexPath.row])
    }

}
