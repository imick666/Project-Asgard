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
    
    var dog: Dog! {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        dogImageView.rounded(nil)
        dogImageView.setDogImage(from: dog.image)
        nameLabel.text = dog.name?.capitalized
        affixLabel.text = dog.affix?.capitalized
    }
    
}
