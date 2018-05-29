//
//  RatingViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var ratingStarts: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingStarts.rating = 0
        self.ratingStarts.settings.fillMode = .full
        // Change the size of the stars
        self.ratingStarts.settings.starSize = 40
        self.ratingStarts.settings.starMargin = Double(self.view.frame.width / 15)

        self.ratingStarts.backgroundColor = UIColor.clear
        
        // Set the color of a filled star
        self.ratingStarts.settings.filledColor = UIColor.starYellow
        
        // Set the border color of an empty star
        self.ratingStarts.settings.emptyBorderColor = UIColor.starYellow
        
        // Set the border color of a filled star
        self.ratingStarts.settings.filledBorderColor = UIColor.starYellow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
