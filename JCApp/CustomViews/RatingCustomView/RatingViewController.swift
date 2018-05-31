//
//  RatingViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var ratingStarts: CosmosView!
    
    var delegate : RatingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TextField delegate
        self.authorTextField.delegate = self
        self.commentTextField.delegate = self
        
        self.ratingStarts.rating = 0
        self.ratingStarts.settings.fillMode = .full
        // Change the size of the stars
        self.ratingStarts.settings.starSize = 35
        self.ratingStarts.settings.starMargin = Double(self.view.frame.width / 15)

        self.ratingStarts.backgroundColor = UIColor.clear
        
        // Set the color of a filled star
        self.ratingStarts.settings.filledColor = UIColor.starYellow
        
        // Set the border color of an empty star
        self.ratingStarts.settings.emptyBorderColor = UIColor.starYellow
        
        // Set the border color of a filled star
        self.ratingStarts.settings.filledBorderColor = UIColor.starYellow
        
        self.ratingStarts.didFinishTouchingCosmos = { rating in
            let ratingInt = Int(rating)
            let comment = self.commentTextField.text
            let author = self.authorTextField.text
            self.delegate?.rateEvent(numberStars: ratingInt, comment: comment, author: author)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let ratingInt = Int(self.ratingStarts.rating)
        let comment = self.commentTextField.text
        let author = self.authorTextField.text
        self.delegate?.rateEvent(numberStars: ratingInt, comment: comment, author: author)
    }
}
