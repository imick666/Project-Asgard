//
//  CreatePuupyViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 02/12/2020.
//

import UIKit

protocol CreatePuppyDelegate {
    func create()
}

class CreatePuppyViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var delegate: CreatePuppyDelegate?

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Methodes
    

}
