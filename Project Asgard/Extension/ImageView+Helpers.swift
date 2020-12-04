//
//  ImageView.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

extension UIImageView {
    
    // MARK: - Properties
    
    var imageHasChanged: Bool {
        return self.image?.pngData() != UIImage(named: "DogPlaceHolder")?.pngData()
    }
    
    var imageOrNil: UIImage? {
        return self.imageHasChanged ? self.image : nil
    }
    
    // MARK: - Methodes
 
    func rounded(_ fillColor: UIColor?) {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = fillColor?.cgColor ?? UIColor.gray.cgColor
    }
    
    func dogImage(from image: Data?) {
        self.image = image != nil ? UIImage(data: image!) : UIImage(named: "DogPlaceHolder")
    }
    
    func resetImage() {
        self.image = UIImage(named: "DogPlaceHolder")
    }
}
