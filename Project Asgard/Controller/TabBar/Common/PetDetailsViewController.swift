//
//  DetailDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import UIKit
import CoreData

class PetDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affixLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var dogColorLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var lofNbLabel: UILabel!
    @IBOutlet weak var chipNbLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var treatmentsViewContainer: UIView!
    @IBOutlet weak var littersViewContainer: UIView!
    @IBOutlet weak var weightViewContainer: UIView!
    
    // MARK: - Properties
    
    var selectedDog: Dog?
    var selectedPuppy: Puppy?
    private var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: - Children ViewController
    
    private var treatementViewController: TreatementViewController {
        guard let vc = children.first(where: {$0 is TreatementViewController}) as? TreatementViewController else {
            fatalError("Failed to get TreatementViewController")
        }
        return vc
    }
    
    private var litterViewController: LitterViewController {
        guard let vc = children.first(where: { $0 is LitterViewController }) as? LitterViewController else {
            fatalError("Failed to load LitterViewController")
        }
        
        return vc
    }
    
    private var weightViewController: WeightViewController {
        guard let vc = children.first(where: { $0 is WeightViewController }) as? WeightViewController else {
            fatalError("Failed to load WeightViewController")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let numberOfPage = Int(scrollView.contentSize.width / scrollView.frame.width)
        pageControl.numberOfPages = numberOfPage
    }
    
    // MARK: - Methodes
    
    private func setupFrc() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        if selectedDog != nil {
            setupDogFrc(context)
        } else if selectedPuppy != nil {
            setupPuppyFrc(context)
        } else {
            fatalError("This view should not be shown")
        }
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
        } catch {
            fatalError("Failed to fetch entities")
        }
    }
    
    private func setupPuppyFrc(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(format: "id == %@", selectedPuppy!.id! as CVarArg)
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupDogFrc(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<NSFetchRequestResult> = Dog.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(format: "id == %@", selectedDog!.id! as CVarArg)
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupView() {
        topView.layer.cornerRadius = 30
        topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowRadius = 10
        topView.layer.shadowOpacity = 0.5
        
    }
    
    private func setupContent() {
        if selectedDog != nil {
            setupDogContent()
        } else if selectedPuppy != nil {
            setupPuppyContent()
        } else {
            navigationController?.popViewController(animated: true)
        }
        let necklaceColor = UIColor(fromHex: selectedPuppy?.necklaceColor)
        pictureImageView.rounded(necklaceColor)
    }
    
    private func setupDogContent() {
        guard let dog = selectedDog,
              let birthDate = dog.birthDate?.ddMMYY,
              let age = dog.birthDate?.age else { return }
        
        nameLabel.text = dog.name?.capitalized
        nameLabel.sizeToFit()
        affixLabel.text = dog.affix?.capitalized
        sexLabel.text = DogSex(rawValue: dog.sex)?.description
        dogColorLabel.text = dog.dogColor.orNc.capitalized
        pictureImageView.setDogImage(from: dog.image)
        birthDateLabel.text = "\(birthDate) (\(age))"
        lofNbLabel.text? = "Lof : \(dog.lofNumber.orNc)"
        chipNbLabel.text = "Chip : \(dog.chipNumber.orNc)"
        
        littersViewContainer.isHidden = false
        treatmentsViewContainer.isHidden = false
        weightViewContainer.isHidden = true
        
        setupChildrens()
    }
    
    private func setupPuppyContent() {
        guard let puppy = selectedPuppy,
              let birthDate = puppy.birthDate?.ddMMYY,
              let age = puppy.birthDate?.age else { return }
        
        nameLabel.text = puppy.name?.capitalized
        affixLabel.text = puppy.affix?.capitalized
        sexLabel.text = DogSex(rawValue: puppy.sex)?.description
        dogColorLabel.text = puppy.puppyColor.orNc
        lofNbLabel.text = puppy.lofNumber.orNc
        chipNbLabel.text = puppy.chipNumber.orNc
        pictureImageView.setDogImage(from: puppy.image)
        birthDateLabel.text = "\(birthDate) (\(age))"
        
        littersViewContainer.isHidden = true
        treatmentsViewContainer.isHidden = false
        weightViewContainer.isHidden = false
        
        setupChildrens()
    }
    
    private func setupChildrens() {
        // Treatements
        var treatements: [Treatement]? {
            if let dog = selectedDog {
                return dog.treatements?.sortedArray(using: [NSSortDescriptor(key: "endDate", ascending: false)]) as? [Treatement]
            } else if let puppy = selectedPuppy {
                return puppy.treatements?.sortedArray(using: [NSSortDescriptor(key: "endDate", ascending: false)]) as? [Treatement]
            } else {
                return nil
            }
        }
        treatementViewController.treatements = treatements ?? [Treatement]()
        
        // Litters
        if !littersViewContainer.isHidden {
            let litters = selectedDog?.litters?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]) as? [DogLitter]
            litterViewController.litters = litters ?? []
            litterViewController.delegate = self
        }
        
        // Weight
        if !weightViewContainer.isHidden {
            let weights = selectedPuppy?.weights?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [Weight]
            weightViewController.weights = weights ?? []
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func didTapEditButton(_ sender: Any) {
        if let dog = selectedDog {
            guard let createDogVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createDog) as? CreateDogViewController else { return }
            
            createDogVC.dogToModify = dog
            present(createDogVC, animated: true, completion: nil)
        }
        if let puppy = selectedPuppy {
            guard let createPuppyVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createPuppy) as? CreatePuppyViewController else { return }
            createPuppyVC.puppyToModify = puppy
            present(createPuppyVC, animated: true, completion: nil)
        }
    }
}

extension PetDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}

extension PetDetailsViewController: LitterViewControllerDelegate {
 
    func litterDidSelect(_ litter: DogLitter) {
        guard let puppiesListVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.puppiesList) as? PuppiesListTableViewController else { return }
        
        puppiesListVC.litter = litter
        show(puppiesListVC, sender: nil)
    }
}

extension PetDetailsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if selectedDog != nil{
            selectedDog = fetchedResultController?.fetchedObjects?.first as? Dog
        }
        if selectedPuppy != nil {
            selectedPuppy = fetchedResultController?.fetchedObjects?.first as? Puppy
        }
        setupContent()
    }
}
