//
//  AddVendersTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/2/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class AddVendersTableViewController: UITableViewController {
	
	//Conforming to VenderListDelegate protocol
	var vender: Vendor?
	
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var website: UITextField!
	@IBOutlet weak var address: UITableViewCell!
	
	// Create a local model that can be initialized with nil values
	private struct LocalVender {
		var name : String?
		var address : String?
		var phone: String?
		var email: String?
		var website : URL?
	}
	//Declare local vender object
	private var localVenderObject : LocalVender?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.keyboardDismissMode = .interactive
		setupLayout()
		localVenderObject = LocalVender() // Initialize local object
		submitButton.isEnabled = false
		submitButton.layer.backgroundColor = UIColor.systemGray.cgColor // temp color
	}
	deinit {
		print("\(self.title ?? "") Controller has been terminated")
	}
	
	func setupLayout(){
		submitButton.layer.cornerRadius = 10
		[name,phone,email,website, address].forEach({$0?.layer.cornerRadius = 5})
	}
	
	//MARK: IBACTIONS
	
	// As user provides input add to nil object localVenderObject
	@IBAction func userInputValueChanged(_ sender: UITextField) {
		switch sender {
			case name:
				localVenderObject?.name = sender.text
				enabledStatusChecker()
			case phone:
				localVenderObject?.phone = sender.text
				enabledStatusChecker()
			case email:
				localVenderObject?.email = sender.text
				enabledStatusChecker()
			case website:
				localVenderObject?.website = URL(string: "https://www.\(sender.text!)")
				enabledStatusChecker()
			default:
				break
		}
	}
	
	func enabledStatusChecker(){
		localVenderObject?.address = "1449 Portola Ave, Deltona, FL, 32725, USA"
		
		if localVenderObject?.name != nil && localVenderObject?.phone != nil && localVenderObject?.email != nil && localVenderObject?.website != nil && localVenderObject?.address != nil {
			submitButton.isEnabled = true
			submitButton.layer.backgroundColor = UIColor.systemBlue.cgColor // temp color
		}
	}
	
	@IBAction func userTappedSubmitButton(_ sender: UIButton) {
		
		
		guard let name = localVenderObject?.name,
			let phone = localVenderObject?.phone,
			let email = localVenderObject?.email,
			let website = localVenderObject?.website,
			let address = localVenderObject?.address
			else
		{
			return
		}
		
		vender = Vendor(name: name,
						address: address,
						phone: phone,
						email: email,
						website: website)
		
		performSegue(withIdentifier: "vender", sender: vender)
		
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
