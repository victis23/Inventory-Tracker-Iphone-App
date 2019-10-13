//
//  NewOrder_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class NewOrder_TableViewController: UITableViewController {
	
	@IBOutlet weak var currentAmount: UILabel!
	@IBOutlet weak var orderAmount: UITableViewCell!
	@IBOutlet weak var needAmountLabel: UITextField!
	var stockObject : Stock!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		amountLabelText(stockObject)
    }
	
	func setAmountLabel(_ model: Stock){
		stockObject = model
	}
	func amountLabelText(_ model :Stock){
		currentAmount.text = String(model.amount!)
	}
	
	
	
	//MARK: IBActions
	
	@IBAction func updatedAmount(_ sender: UITextField) {
		
		guard let neededAmount = needAmountLabel.text, let intNeedAmount = Int(neededAmount), let amount = stockObject.amount else {return}
		
		let newAmount = amount - intNeedAmount
		let amountText :String = "\(newAmount)"
		currentAmount.text = amountText
		print(amountText)
	}

}


