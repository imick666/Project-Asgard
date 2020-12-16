//
//  DetailDogViewController.swift
//  Project Asgard
//
//  Created by mickael ruzel on 24/11/2020.
//

import UIKit
import CoreData

class DetailPuppyViewController: UIViewController {

    // MARK: - Outlets
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affixLabel: UILabel!
    @IBOutlet weak var pictureImageViw: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var puppyColorLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var lofNbLabel: UILabel!
    @IBOutlet weak var chipNbLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Properties
    
    var puppy: Puppy!
    
    private var fetchResultController: NSFetchedResultsController<Puppy>?
    
    // MARK: - Children ViewController
    
    private var treatementViewController: TreatementViewController {
        guard let vc = children.first(where: {$0 is TreatementViewController}) as? TreatementViewController else {
            fatalError("Failed to get TreatementViewController")
        }
        return vc
    }
    
    private var weightViewController: WeightViewController {
        guard let vc = children.first(where: { $0 is WeightViewController }) as? WeightViewController else {
            fatalError("Failed to get WeightsViewController")
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
        let request: NSFetchRequest<Puppy> = Puppy.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        request.predicate = NSPredicate(format: "id == %@", puppy.id! as CVarArg)
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainContext else { return }
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController?.delegate = self
        
        do {
            try fetchResultController?.performFetch()
        } catch {
            fatalError("Failed to fecth entities")
        }
    }
    
    private func setupView() {
        
        topView.layer.cornerRadius = 30
        topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        topView.layer.shadowColor = UIColor.gray.cgColor
        topView.layer.shadowRadius = 10
        topView.layer.shadowOpacity = 0.5
    }
    
    private func setupContent() {
        guard let puppy = puppy,
              let birthDate = puppy.birthDate?.ddMMYY,
              let age = puppy.birthDate?.age else { return }
        
        nameLabel.text = puppy.name?.capitalized
        nameLabel.sizeToFit()
        affixLabel.text = puppy.affix?.capitalized
        sexLabel.text = DogSex(rawValue: puppy.sex)?.description
        puppyColorLabel.text = puppy.puppyColor.orNc.capitalized
        pictureImageViw.setDogImage(from: puppy.image)
        pictureImageViw.rounded(UIColor(fromHex: puppy.necklaceColor))
        birthDateLabel.text = "\(birthDate) (\(age))"
        lofNbLabel.text? = "Lof : \(puppy.lofNumber.orNc)"
        chipNbLabel.text = "Chip : \(puppy.chipNumber.orNc)"
        
        setupChildrens()
    }
    
    private func setupChildrens() {
        // Treatements
        let treatement = puppy?.treatements?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Treatement]
        treatementViewController.treatements = treatement ?? [Treatement]()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapEditButton(_ sender: Any) {
        guard let createPuppyVC = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.createPuppy) as? CreatePuppyViewController else { return }
        createPuppyVC.puppyToModify = puppy
        
        present(createPuppyVC, animated: true, completion: nil)
    }
    
}

extension DetailPuppyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}

extension DetailPuppyViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        puppy = fetchResultController?.fetchedObjects?.first
        setupContent()
    }
}

