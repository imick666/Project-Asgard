//
//  CreateLitterViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 02/12/2020.
//

import UIKit

class CreateLitterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cesareanSwitch: UISwitch!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Properties
    
    private var puppies = [Puppy]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - Methodes
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let createPuppyNib = UINib(nibName: Constants.Cells.createPuppyCellNib, bundle: .main)
        tableView.register(createPuppyNib, forCellReuseIdentifier: Constants.Cells.createPuppyCellID)
    }
    
    @objc
    private func addPuppy() {
        print("Add Puppy")
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        
    }

}

// MARK: - TableView

extension CreateLitterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return puppies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Add Puppy", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addPuppy), for: .touchUpInside)
        
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    // MARK: - TableView Delegate
}
