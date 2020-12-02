//
//  SplitViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    // MARK: - Properties
    
    var masterView: DogListTableViewController!
    var detailView: DetailDogViewController!
    var coreData: CoreDataManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChild()
        setupCoreData()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(notificationReceive), name: .changeDog, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailView.selectedDog = coreData?.allDogs.first
    }
    
    // MARK: - Methodes
    
    @objc
    private func notificationReceive() {
        masterView.tableView.reloadData()
        detailView.selectedDog = coreData?.allDogs.first(where: {$0 == detailView.selectedDog})
    }
    
    private func setupChild() {
        masterView = (viewControllers.first as? UINavigationController)?.topViewController as? DogListTableViewController
        detailView = (viewControllers.last as? UINavigationController)?.topViewController as? DetailDogViewController
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
    }
}
