//
//  InventoryDetailCell_CollectionViewCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class InventoryDetailCell_CollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var backGroundViewForCell : UIView!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var percentageRemainingLabel: UILabel!
	@IBOutlet weak var stockWeightLabel: UILabel!
	@IBOutlet weak var stockSizeLabel: UILabel!
	@IBOutlet weak var stockColorLabel: UILabel!
	@IBOutlet weak var cartonStatus: UIImageView!
	@IBOutlet weak var vendorLabel: UILabel!
	
}
