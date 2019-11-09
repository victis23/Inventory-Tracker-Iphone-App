//
//  LandingPageViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/8/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

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
	func setAesthetics(){
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
