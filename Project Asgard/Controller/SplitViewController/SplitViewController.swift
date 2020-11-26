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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailView.selectedDog = coreData?.allDogs.first
    }
    
    // MARK: - Methodes
    
    private func setupChild() {
        masterView = (viewControllers.first as? UINavigationController)?.topViewController as? DogListTableViewController
        detailView = (viewControllers.last as? UINavigationController)?.topViewController as? DetailDogViewController
    }
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else { return }
        coreData = CoreDataManager(stack)
    }
}

extension SplitViewController: CreateDogDelegate {
    func createDog(named name: String, _ affix: String, birthThe date: Date, lofNumber: String?, chipNumber: String?, picture: Data?) {
        
        coreData?.createDog(named: name, affix, birthThe: date, lofNumber: lofNumber, chipNumber: chipNumber, pitcure: picture)
        
        masterView.tableView.reloadData()
    }
}
