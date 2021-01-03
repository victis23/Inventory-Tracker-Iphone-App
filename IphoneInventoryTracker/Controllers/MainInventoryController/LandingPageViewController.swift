//
//  LandingPageViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/8/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Landing page for user that functions as a home page containing four options
/// - Vendors : Contains list of venders where users can access contact info.
/// - Inventory : List of inventory.
/// - Paper Calculator : Calculates how many sheets a user can cut out from a parent sheet.
/// - Expenses: Totals spent for each item in inventory.
class LandingPageViewController: UIViewController {
	//MARK: IBOutlets
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var logoForegroundView: UIView!
	@IBOutlet weak var vendorButton: UIButton!
	@IBOutlet weak var buttomLeftButton: UIButton!
	@IBOutlet weak var inventoryButton: UIButton!
	@IBOutlet weak var buttomRightButton: UIButton!
	
	//MARK: State
	override func viewDidLoad() {
		super.viewDidLoad()
		setAesthetics()
	}
	
	/// Sets visable aesthetics for viewcontroller.
	func setAesthetics() {
		//Buttons in temporary collection get properties set.
		[vendorButton,buttomLeftButton,buttomRightButton,inventoryButton].forEach({
			$0?.layer.cornerRadius = 15
		})
		// Logo and logo foreground get converted to circles.
		[logoImage,logoForegroundView].forEach({
			$0?.layer.cornerRadius = $0!.frame.size.width / 2
		})
	}
	
	
	
}
