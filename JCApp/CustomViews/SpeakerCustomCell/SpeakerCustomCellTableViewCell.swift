//
//  SpeakerCustomCellTableViewCell.swift
//  JCApp
//
//  Created by Jose Lino Neto on 03/06/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit
import JCApiClient

class SpeakerCustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var speakerPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var localEvent: Event?
    var event: Event? {
        get {
            return localEvent
        }
        set {
            localEvent = newValue
            
            self.nameLabel.text = localEvent?.name
            self.descriptionLabel.text = localEvent?.subject
            self.speakerPhoto.image = localEvent?.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
