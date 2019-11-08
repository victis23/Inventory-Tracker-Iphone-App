//
//  CustomCellTableViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/7/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
	// nameLabel property for cell that will display the name of each parent sheet size.
	@IBOutlet weak var nameLabel :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
