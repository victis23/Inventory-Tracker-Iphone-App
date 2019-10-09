//
//  NewStock_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class NewStock_TableViewController: UITableViewController {

	@IBOutlet weak var stockName: UITextField!
	@IBOutlet weak var sheetSizeLabel: UILabel!
	@IBOutlet weak var stockWeightLabel: UILabel!
	@IBOutlet weak var venderLabel: UILabel!
	@IBOutlet weak var costPer1000Sheets: UITextField!
	@IBOutlet weak var initialAmount: UITextField!
	@IBOutlet weak var recommendedAmount: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	var newStock :Stock?
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		newStock = Stock(nil, nil, nil, nil, nil, nil)
    }
	
	func updateNewStock(_ incoming : Stock){
		
		if incoming.name != nil {
			newStock?.name = incoming.name
		}
		if incoming.parentSheetSize != nil {
			newStock?.parentSheetSize = incoming.parentSheetSize
		}
		if incoming.weight != nil {
			newStock?.weight = incoming.weight
		}
		if incoming.amount != nil {
			newStock?.amount = incoming.amount
		}
		if incoming.recommendedAmount != nil{
			newStock?.recommendedAmount = incoming.recommendedAmount
		}
		if incoming.vender != nil{
			newStock?.vender = incoming.vender
		}
		print(newStock!)
	}

	//MARK: Navigation
	
	@IBAction func unwindToNewStock(_ unwindSegue: UIStoryboardSegue) {
//		let sourceViewController = unwindSegue.source
		// Use data from the view controller which initiated the unwind segue
	}
}
