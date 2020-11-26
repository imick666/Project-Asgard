//
//  DetailDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import UIKit

class DetailDogViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var selectedDog: Dog? {
        didSet {
            setupView()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Methodes
    
    private func setupView() {
        
        title = selectedDog?.name
    }

}
