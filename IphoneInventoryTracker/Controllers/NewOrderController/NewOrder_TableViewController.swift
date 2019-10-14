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
	@IBOutlet weak var needAmountLabel: UITextField!
	@IBOutlet weak var submitButton :UIButton!

	var stockObject : Stock!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		setupSubmitButtonAsthetics()
		amountLabelText(stockObject)
    }
	
	func setupSubmitButtonAsthetics(){
		submitButton.layer.cornerRadius = 10
	}
	
	func setAmountLabel(_ model: Stock){
		stockObject = model
	}
	func amountLabelText(_ model :Stock){
		currentAmount.text = String(model.amount!)
	}
	
	
	
	//MARK: IBActions
	
	
	
}


