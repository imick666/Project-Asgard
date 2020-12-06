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
}
