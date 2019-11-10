//
//  CostTableViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Cell displayed on `CostOfSpentGoods`...
class CostTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var costLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
