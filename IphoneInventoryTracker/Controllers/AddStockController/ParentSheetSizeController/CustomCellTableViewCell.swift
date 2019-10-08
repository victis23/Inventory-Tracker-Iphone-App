//
//  CustomCellTableViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/7/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
