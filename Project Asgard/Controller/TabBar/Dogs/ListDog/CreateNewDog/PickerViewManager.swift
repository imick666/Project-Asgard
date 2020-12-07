//
//  PickerViewManager.swift
//  Project Asgard
//
//  Created by mickael ruzel on 23/11/2020.
//

import UIKit

class PickerViewManager: UIImagePickerController {

    // MARK: - Properties
    
    private var viewController: UIViewController?
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Methodes
    
    func presentAlert(from controller: UIViewController) {
        viewController = controller
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            
            controller.present(picker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            
            controller.present(picker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(photoLibraryAction)
        }
        
        actionSheet.addAction(cancelAction)
        
        viewController?.present(actionSheet, animated: true, completion: nil)
        
    }
    
}

extension PickerViewManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        completionHandler?(image)
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
