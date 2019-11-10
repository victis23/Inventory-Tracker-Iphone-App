//
//  StockWeight_TableViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Cell that will be displayed in table view for StockWeight...
class StockWeight_TableViewCell: UITableViewCell {
	//Label property for tableview cell.
	@IBOutlet weak var weightLabel :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
