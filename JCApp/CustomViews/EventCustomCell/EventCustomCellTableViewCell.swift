//
//  EventCustomCellTableViewCell.swift
//  JCApp
//
//  Created by Jose Lino Neto on 22/05/18.
//  Copyright © 2018 Jose Lino Neto. All rights reserved.
//

import UIKit

class EventCustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
