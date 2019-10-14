//
//  VenderContactInfo_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class VenderContactInfo_TableViewController: UITableViewController {
	
	@IBOutlet weak var supplierName :UILabel!
	@IBOutlet weak var phoneNumberLabel : UILabel!
	@IBOutlet weak var emailAddressLabel : UILabel!
	@IBOutlet weak var physicalAddressLine1Label : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe2 : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe3 : UILabel!
	@IBOutlet weak var websiteLabel : UILabel!
	
	var contactInformation : VenderInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
		setvaluesForVender()
		
    }
	
	func setvaluesForVender(){
		supplierName.text = contactInformation.name.rawValue
		phoneNumberLabel.text = contactInformation.phone
		emailAddressLabel.text = contactInformation.email
		
		guard let website = contactInformation.website else {return}
		websiteLabel.text = "\(website)"
		
		let address = contactInformation.address.split(separator: ",")
		physicalAddressLine1Label.text = String(address[0])
		physicalAddressLine1Labe2.text = String(address[1])
		physicalAddressLine1Labe3.text = "\(address[2]), \(address[3])"
	}
	
}
