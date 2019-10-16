//
//  NewOrder_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class NewOrder_TableViewController: UITableViewController, UITextFieldDelegate {
	
	@IBOutlet weak var currentAmount: UILabel!
	@IBOutlet weak var orderAmount: UITableViewCell!
	@IBOutlet weak var neededAmountTextField: UITextField!
	@IBOutlet weak var submitButton :UIButton!

	var stockObject : Stock!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		setControllerTitle()
		setupSubmitButtonAsthetics()
		amountLabelText(stockObject)
		
    }
	
	func setControllerTitle(){
		guard let weight = stockObject.weight else {return}
		self.title = "New Order of \(weight.rawValue)"
	}
	
	func setupSubmitButtonAsthetics(){
		submitButton.layer.cornerRadius = 10
	}
	
	// Gets called from originating controller
	func setModelForController(_ model: Stock){
		stockObject = model
	}
	func amountLabelText(_ model :Stock){
		currentAmount.text = String(model.amount!)
	}
	
	
	
	//MARK: IBActions
	
	@IBAction func tappedSubmitButton(_ sender: UIButton){
		// Temporary Value To Test Method —
		guard let neededAmountForNewOrder = neededAmountTextField.text, let neededAmountAsInteger = Int(neededAmountForNewOrder) else {return}
		stockObject.performCalculations(neededAmountAsInteger)
		print("\(stockObject.amount!)")
	}
	
}


