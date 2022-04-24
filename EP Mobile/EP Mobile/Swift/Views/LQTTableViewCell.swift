//
//  LQTTableViewCell.swift
//  EP Mobile
//
//  Created by David Mann on 8/13/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

class LQTTableViewCell: UITableViewCell {

    @IBOutlet var subtypeLabel: UILabel!

    @IBOutlet var channelLabel: UILabel!
    
    @IBOutlet var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
