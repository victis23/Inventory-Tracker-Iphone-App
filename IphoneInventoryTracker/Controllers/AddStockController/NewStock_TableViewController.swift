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
	@IBOutlet weak var colorTextField: UITextField!
	
	var newStock :Stock?
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setEmptyModelValue()
		setTextFieldTags()
    }
	
	func setEmptyModelValue(){
		newStock = Stock(nil, nil, nil, nil, nil, nil)
	}
	
	func setTextFieldTags(){
		stockName.tag = 1
		costPer1000Sheets.tag = 2
		initialAmount.tag = 3
		recommendedAmount.tag = 4
		colorTextField.tag = 5
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

	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
			case 1:
				stockName.resignFirstResponder()
			case 2:
				stockName.resignFirstResponder()
			case 3:
				stockName.resignFirstResponder()
			default:
			break
		}
	}
	
	
	@IBAction func nameUpdate(_ sender: UITextField) {
		
		switch sender.tag {
			case 1:
			guard let stockName = stockName.text else {return}
				let name = Stock(stockName)
				updateNewStock(name)
			case 2:
				guard let costPer100 = costPer1000Sheets.text else {return}
				newStock?.cost = costPer100
				print(newStock ?? "nil")
				
			case 3:
				guard let initialAmount = initialAmount.text, let amount = Int(initialAmount) else {return}
				let startingAmount = Stock(nil, nil, nil, amount, nil, nil)
				updateNewStock(startingAmount)
			case 4:
				guard let recommendedAmount = recommendedAmount.text, let amount = Int(recommendedAmount) else {return}
				let recommended = Stock(nil, nil, nil, nil, amount, nil)
				updateNewStock(recommended)
			case 5:
				guard let color = colorTextField.text else {return}
				newStock?.color = color
				print(newStock ?? "nil")
				
			default:
			break
		}
		if newStock?.name != nil && newStock?.name != "" && newStock?.cost != nil && newStock?.amount != nil && newStock?.recommendedAmount != nil && newStock?.color != nil && newStock?.color != "" && newStock?.parentSheetSize != nil && newStock?.weight != nil && newStock?.vender != nil {
			saveButton.isEnabled = true
		}else{
			saveButton.isEnabled = false
		}
	}
	@IBAction func finishedTyping(_ sender: Any) {
		guard let stockName = stockName.text else {return}
		let name = Stock(stockName)
		updateNewStock(name)
		view.endEditing(true)
	}
}

//MARK: Navigation
extension NewStock_TableViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let identifier = "done"
		if segue.identifier == identifier {
			print("Saving...")
			let destination = segue.destination as! InventoryTracker_CollectionViewController
			guard let stock = newStock else {return}
			destination.stock?.append(stock)
			destination.createSnapShot(destination.stock)
			/*
			var stockImport : [Stock] = []
			stockImport.append(stock)
			destination.createSnapShot(stockImport)
			*/
		}
	}
}
