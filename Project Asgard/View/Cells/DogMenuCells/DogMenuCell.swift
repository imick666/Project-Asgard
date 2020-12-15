//
//  DogMenuCell.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class DogMenuCell: UITableViewCell {

    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var affixLabel: UILabel!
    
    var dog: Dog? {
        didSet {
            setupDog()
        }
    }
    
    var puppy: Puppy? {
        didSet {
            setupPuppy()
        }
    }
    
    private func setupDog() {
        guard let dog = dog else { return }
        dogImageView.rounded(nil)
        dogImageView.setDogImage(from: dog.image)
        nameLabel.text = dog.name?.capitalized
        affixLabel.text = dog.affix?.capitalized
    }
    
    private func setupPuppy() {
        guard let puppy = puppy else { return }
        dogImageView.rounded(UIColor(fromHex: puppy.necklaceColor))
        dogImageView.setDogImage(from: puppy.image)
        nameLabel.text = puppy.name?.capitalized
        affixLabel.text = puppy.affix?.capitalized
    }
}
