//
//  VenderCell_TableViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/2/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class VenderCell_TableViewCell: UITableViewCell {
	
	//Cell that displays on VenderList_TableViewController.swift
	@IBOutlet weak var companyName: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
