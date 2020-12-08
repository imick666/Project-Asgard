//
//  TreatementViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 27/11/2020.
//

import UIKit
import CoreData

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
        if let vc = parent as? DetailDogViewController {
            return vc
        } else if let vc = parent as? DetailPuppyViewController {
            return vc
        } else {
            fatalError("Failed to load parent ViewController")
        }
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCoreData()
        
        view.layer.cornerRadius = 30
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 2
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
        
        if let detailDog = parentView as? DetailDogViewController {
            createTreatementVC.forObject = detailDog.selectedDog
        } else if let detailPuppy = parentView as? DetailPuppyViewController {
            createTreatementVC.forObject = detailPuppy.selectedPuppy
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
        
        cell.textLabel?.text = treatements[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var alert: UIAlertController!
        let vc = DetailTreatementViewController()
        vc.treatement = treatements[indexPath.row]
        vc.preferredContentSize.height = parentView.view.bounds.height * 0.4
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        case .pad:
            alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        default:
            return
        }
        
        alert.setTitle(treatements[indexPath.row].name!, font: UIFont.systemFont(ofSize: 25, weight: .semibold), titleColor: nil)
        
        alert.setContentViewController(vc)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.confirmDeleteAction { (cancelled) in
                switch cancelled {
                case true:
                    self.present(alert, animated: true, completion: nil)
                case false:
                    self.coreData?.deteObject(self.treatements[indexPath.row])
                    self.sendNotification()
                }
            }
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