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
    
    private var parentView: DetailDogViewController {
        guard let vc = parent as? DetailDogViewController else {
            fatalError("failed to load parent VC")
        }
        return vc
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func sendNotification() {
        let notifictionCenter = NotificationCenter.default
        notifictionCenter.post(Notification.init(name: .changeDog))
    }

    // MARK: - Actions
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let createTreatementVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createTreatement) as? CreateTreatementViewController else {
            return
        }
        
        createTreatementVC.forDog = parentView.selectedDog
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
        
        cell.textLabel?.text = treatements[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.setTitle(treatements[indexPath.row].name!, font: UIFont.systemFont(ofSize: 25, weight: .semibold), titleColor: UIColor.red)
        
        let vc = DetailTreatementViewController()
        vc.treatement = treatements[indexPath.row]
        vc.preferredContentSize.height = view.bounds.height * 0.4
        alert.setContentViewController(vc)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.coreData?.deteObject(self.treatements[indexPath.row])
            self.sendNotification()
        }
        alert.addAction(okAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
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
        return treatements.count == 0 ? tableView.bounds.height : 0
    }
}
