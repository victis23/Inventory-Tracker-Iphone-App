//
//  AddVendersTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/2/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import Combine



class AddVendersTableViewController: UITableViewController, CompanyAddressDelegate  {
	
	/// This function recieves the address that will be displayed in the contact window of VenderList_TableViewController.swift.
	/// - Parameter location: Property recieved when GoogleMapVenderLocation_ViewController.swift is dismissed.
	/// - Note: This is a required Method.
	func getCompanyAddress(from location:String) {
		addressText = location
	}
	
	//MARK: Local Properties
	
	//Variable that will be passed back over the unwind segue.
	var vender: Vendor?
	// Changes address property of temporaryVender when updated.
	private var addressText : String = String(){
		didSet{
			temporaryVender?.address = addressText
		}
	}
	// Create a local model that can be initialized with nil values.
	private struct LocalVender {
		var name : String?
		var address : String?
		var phone: String?
		var email: String?
		var website : URL?
	}
	//We create the local vender object that will hold our temporary values.
	private var temporaryVender : LocalVender? = LocalVender(){
		didSet {
			if temporaryVender?.address == nil {
				print("Shit We're nil")
			}
		}
	}
	
	//MARK: IBOutlet Properties
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var name: UITextField!
	@IBOutlet weak var phone: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBOutlet weak var website: UITextField!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var addressCell: UITableViewCell!
	
	
	
	//MARK: View State Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.keyboardDismissMode = .interactive
		setupLayout()
		submitButton(isEnabled: false)
		
	}
	deinit {
		print("\(self.title ?? "") Controller has been terminated")
	}
	
	//MARK: Aesthetics
	
	/// For loop that will be modifiying layer of each containing object.
	func setupLayout(){
		submitButton.layer.cornerRadius = 10
		[name,phone,email,website, address].forEach({$0?.layer.cornerRadius = 5})
		// Temporary Color For Inactive Submit Button.
	}
	
	//MARK: IBACTIONS Methods
	
	/// Values are added to temporaryVender property accordingly, based off of incoming sender name identification.
	/// - Parameter sender: IBOutlet Item For specific user action
	@IBAction func userInputValueChanged(_ sender: UITextField) {
		guard  sender.text != nil else {return}
		switch sender {
			case name:
				temporaryVender?.name = sender.text
				enabledStatusChecker()
			case phone:
				temporaryVender?.phone = sender.text
				enabledStatusChecker()
			case email:
				temporaryVender?.email = sender.text
				enabledStatusChecker()
			case website:
				temporaryVender?.website = URL(string: "https://www.\(sender.text!)")
				enabledStatusChecker()
			default:
				break
		}
	}
	
	/// Assigns temporary values to a completed Vender Struct Object
	/// Performs an UNWIND segue --> VenderList_TableViewController.swift.
	/// - Parameter sender: IBOutlet Object Button — Not used in this Method.
	@IBAction func userTappedSubmitButton(_ sender: UIButton) {
		guard let name = temporaryVender?.name,
			let phone = temporaryVender?.phone,
			let email = temporaryVender?.email,
			let website = temporaryVender?.website,
			let address = temporaryVender?.address
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
	
	//MARK: Custom Methods
	
	/// Checking for delegate
	/// Determining whether each of the properties within our local vender object are not nil in order to activate our submit button.
	/// - Note: This is a required Method.
	func enabledStatusChecker(){
		if temporaryVender?.name != nil && temporaryVender?.phone != nil && temporaryVender?.email != nil && temporaryVender?.website != nil && temporaryVender?.address != nil && name.text != "" && phone.text != "" && email.text != "" && address.text != "" && website.text != "" {
			// Protections after confirming that value is not nil, checks to make sure email contains required fields.
			guard let emailValue = temporaryVender?.email, emailValue.contains("@") else {
				//Makes temporaryVender.email == nil & email field becomes first responder.
				temporaryVender?.email = nil
				submitButton(isEnabled: false)
				email.becomeFirstResponder()
				return
			}
			submitButton(isEnabled: true)
		}else{
			// If anything changes that would invalidate the users input values — no button for you.
			submitButton(isEnabled: false)
		}
		// If the address property on the temporaryVender has a value this updates the text property of the corresponding UILabel.
		if temporaryVender?.address != nil {
			address.textColor = .label
			addressCell.accessoryType = .none
			addressCell.isUserInteractionEnabled = false
			guard let addressValue = temporaryVender?.address?.prefix(13) else {return}
			address.text = "\(addressValue)..."
		}
	}
	// FIXME: Temporary Colors.
	//Controls the appearence of the submit button depending on isEnabled State.
	func submitButton(isEnabled:Bool){
		switch isEnabled {
			case true:
				submitButton.isEnabled = isEnabled
				submitButton.layer.backgroundColor = UIColor.systemBlue.cgColor
				submitButton.alpha = 1.0
			default:
				submitButton.isEnabled = isEnabled
				submitButton.layer.backgroundColor = UIColor.systemGray.cgColor
				submitButton.alpha = 0.4
		}
	}
	
	
	// MARK: - DATASOURCE & DELEGATES For STATIC TABLEVIEW CONTROLLER
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath == IndexPath(item: 1, section: 0){
			let googleController = GoogleMapVenderLocation_ViewController()
			googleController.delegate = self
			present(googleController, animated: true, completion: nil)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
