//
//  UIViewControllerExtension.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertMessage(message: String, dismiss: Bool) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if dismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertMessage(title: String, message: String, dismiss: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if dismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
