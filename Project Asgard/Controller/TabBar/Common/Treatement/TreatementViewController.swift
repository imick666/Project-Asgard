//
//  TreatementViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 27/11/2020.
//

import UIKit

class TreatementViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var treatements = [Treatement]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var coreData: CoreDataManager?
    
    private var parentView: UIViewController {
        if let vc = parent as? PetDetailsViewController {
            return vc
        } else {
            fatalError("Failed to load parent ViewController")
        }
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupCoreData()
    }
    
    // MARK: - Methodes
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
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
        guard let createTreatementVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createTreatement) as? CreateTreatementViewController,
              let petDetail = parentView as? PetDetailsViewController else {
            return
        }
        
        if let dog = petDetail.selectedDog {
            createTreatementVC.objects = [dog]
        }
        if let puppy = petDetail.selectedPuppy {
            createTreatementVC.objects = [puppy]
        }
        
        parent?.present(createTreatementVC, animated: true, completion: nil)
    }
}

extension TreatementViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treatements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if treatements[indexPath.row].endDate! < Date() {
            cell.textLabel?.textColor = .gray
        } else {
            cell.textLabel?.textColor = .black
        }
        cell.textLabel?.text = treatements[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let treatment = treatements[indexPath.row]
        
        showTreatmentDeatil(for: treatment, coreData: coreData)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No treatements for the moments, come back later..."
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return treatements.isEmpty ? tableView.frame.height : 0
    }
}
