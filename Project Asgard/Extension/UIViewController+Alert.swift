//
//  UIViewController+Alert.swift
//  Project Asgard
//
//  Created by mickael ruzel on 06/12/2020.
//

import UIKit

extension UIViewController {
    func confirmDeleteAction(cancelled: @escaping (Bool) -> Void) {
        let title = "Warning"
        let message = """
        Are you sure you want to delete this element?
        this action will definitly erase this element
        """
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (_) in
            cancelled(false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            cancelled(true)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        show(alert, sender: nil)
    }
    
    func showTreatmentDeatil(for treatment: Treatement, coreData: CoreDataManager?) {
        
        var alert: UIAlertController!
        let vc = DetailTreatementViewController()
        vc.treatement = treatment
        vc.preferredContentSize.height = 250

        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.setTitle(treatment.name!, font: UIFont.systemFont(ofSize: 25, weight: .semibold), titleColor: nil)
        
        alert.setContentViewController(vc)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.confirmDeleteAction { (cancelled) in
                switch cancelled {
                case true:
                    self.showTreatmentDeatil(for: treatment, coreData: coreData)
                case false:
                    coreData?.deleteObject(treatment)
                }
            }
        }
        alert.addAction(okAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
