//
//  SpeakerDetailsViewController.swift
//  JCApp
//
//  Created by Jose Lino Neto on 29/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class SpeakerDetailsViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var item: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let localEvent = self.item else {
            return
        }
        
        self.nameLabel.text = localEvent.name
        self.descriptionLabel.text = localEvent.subject
        self.profileImage.image = localEvent.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
