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
    
    private var puppies = [Puppy]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var coreData: CoreDataManager?
    var forDog: Dog!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    // MARK: - Methodes
    
    private func setupCoreData() {
        guard let stack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack else {
            fatalError("Failed to load CoreDataStack")
        }
        coreData = CoreDataManager(stack)
    }
    
    private func setupView() {
        cancelButton.roundFilled(wih: .red)
        doneButton.roundFilled(wih: .green)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func sendNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(Notification(name: .changeDog))
    }
    
    @objc
    private func addPuppy() {
        guard let createPuppyVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createPuppy) as? CreatePuppyViewController else { return }
        
        present(createPuppyVC, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        let date = datePicker.date
        let cesarean = cesareanSwitch.isOn
        guard puppies.count != 0 else {
            // TODO: add alert
            // You must add a leats one puppy
            return
        }
        
        coreData?.createLitter(of: forDog, the: date, cesarean: cesarean, with: puppies)
        
        dismiss(animated: true) {
            self.sendNotification()
        }
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
        return 44
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
        return 44
    }
    
    // MARK: - TableView Delegate
}
