//
//  DetailDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import UIKit
import CoreData

class DetailDogViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affixLabel: UILabel!
    @IBOutlet weak var pictureImageViw: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var lofNbLabel: UILabel!
    @IBOutlet weak var chipNbLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    
    var selectedDog: Dog?
    private var frc: NSFetchedResultsController<Dog>?
    
    // MARK: - Children ViewController
    
    private var treatementViewController: TreatementViewController {
        guard let vc = children.first(where: {$0 is TreatementViewController}) as? TreatementViewController else {
            fatalError("Failed to get TreatementViewController")
        }
        return vc
    }
    
    private var litterViewController: LitterViewController {
        guard let vc = children.first(where: { $0 is LitterViewController }) as? LitterViewController else {
            fatalError("Failed to load LitterVeiwController")
        }
        
        return vc
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        scrollView.delegate = self
        setupContent()
        setupFrc()
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        let request: NSFetchRequest<Dog> = Dog.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
        } catch {
            print("hoho")
        }
    }
    
    private func setupView() {
        
        topView.layer.cornerRadius = 30
        topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowRadius = 10
        topView.layer.shadowOpacity = 0.5
        
        pictureImageViw.rounded(nil)
    }
    
    private func setupContent() {
        guard let dog = selectedDog,
              let birthDate = dog.birthDate?.ddMMYY,
              let age = dog.birthDate?.age else { return }
        
        nameLabel.text = dog.name?.capitalized
        nameLabel.sizeToFit()
        affixLabel.text = dog.affix?.capitalized
        sexLabel.text = DogSex(rawValue: dog.sex)?.description
        pictureImageViw.setDogImage(from: dog.image)
        birthDateLabel.text = "\(birthDate) (\(age))"
        lofNbLabel.text? = "Lof : \(dog.lofNumber.orNc)"
        chipNbLabel.text = "Chip : \(dog.chipNumber.orNc)"
        
        setupChildrens()
    }
    
    private func setupChildrens() {
        // Treatements
        let treatement = selectedDog?.treatements?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Treatement]
        treatementViewController.treatements = treatement ?? [Treatement]()
        
        // Litters
        let litters = selectedDog?.litter?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [DogLitter]
        litterViewController.litters = litters ?? [DogLitter]()
        litterViewController.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func didTapEditButton(_ sender: Any) {
        guard let createDogVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createDog) as? CreateDogViewController else { return }
        
        createDogVC.dog = selectedDog
        present(createDogVC, animated: true, completion: nil)
    }
}

extension DetailDogViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}

extension DetailDogViewController: LitterViewControllerDelegate {
 
    func litterDidSelect(_ litter: DogLitter) {
        guard let puppiesListVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.puppiesList) as? PuppiesListTableViewController else { return }
        
        puppiesListVC.puppies = litter.puppies?.allObjects as? [Puppy] ?? [Puppy]()
        puppiesListVC.allPuppies = false
        show(puppiesListVC, sender: nil)
    }
}

extension DetailDogViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        selectedDog = frc?.fetchedObjects?.first(where: { $0.objectID == self.selectedDog?.objectID })
        setupContent()
    }
}
