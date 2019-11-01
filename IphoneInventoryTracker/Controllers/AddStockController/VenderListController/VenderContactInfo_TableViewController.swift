//
//  VenderContactInfo_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class VenderContactInfo_TableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var supplierName :UILabel!
	@IBOutlet weak var phoneNumberLabel : UILabel!
	@IBOutlet weak var emailAddressLabel : UILabel!
	@IBOutlet weak var physicalAddressLine1Label : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe2 : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe3 : UILabel!
	@IBOutlet weak var websiteLabel : UILabel!
	
	var contactInformation : VenderInfo!
	//Index Paths
	let phoneNumberIndexPath = IndexPath(row: 0, section: 1)
	let emailIndexPath = IndexPath(item: 1, section: 1)
	let websiteIndexPath = IndexPath(item: 3, section: 1)

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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath {
			case phoneNumberIndexPath:
			print("phone")
			case emailIndexPath:
			print("email")
			case websiteIndexPath:
			print("website")
			default:
			break
		}
	}
	
}
