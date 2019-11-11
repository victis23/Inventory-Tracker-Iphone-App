//
//  NewStock_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Allows user to add a new item to the inventory list.
class NewStock_TableViewController: UITableViewController {
	
	//MARK: IBOutlets
	
	@IBOutlet weak var stockName: UITextField!
	@IBOutlet weak var sheetSizeLabel: UILabel!
	@IBOutlet weak var stockWeightLabel: UILabel!
	@IBOutlet weak var venderLabel: UILabel!
	@IBOutlet weak var costPer1000Sheets: UITextField!
	@IBOutlet weak var initialAmount: UITextField!
	@IBOutlet weak var recommendedAmount: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var colorTextField: UITextField!
	
	//MARK: Properties
	
	var newStock :Stock?
	
	//MARK: State
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setEmptyModelValue()
		setTextFieldTags()
		tableView.keyboardDismissMode = .interactive
	}
	
	//MARK: Methods
	
	/// Initializes a `Stock` object that has every property set to nil.
	/// - Note: This could have also just be simply initialized as `newStock = Stock()`
	func setEmptyModelValue(){
		newStock = Stock(nil, nil, nil, nil, nil, nil)
	}
	
	/// Sets tags to be used as identifiers for the controller's `IBOutlets`
	func setTextFieldTags(){
		stockName.tag = 1
		costPer1000Sheets.tag = 2
		initialAmount.tag = 3
		recommendedAmount.tag = 4
		colorTextField.tag = 5
	}
	
	/// Checks to see if specified property is `!=nil` if true the value input provided by the user is assigned to the property.
	/// - Parameter incoming: Model to be evaluated.
	/// - Note: This seems convoluted in execution.
	/// - Important: This method is functioning as a secondary barrier before assigning values to our local `Stock` Object. The one that will actually be exported from this view. We could have assigned the values directly but did this to make sure each incoming value was valid.
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
	}
	
	/// Sets amount spent based on the original amount set by user and the cost per 1000
	func setSpentAmount(){
		guard let amount = newStock?.amount else {return}
		guard let costPer1000 = newStock?.cost else {return}
		let costPerAmountPurchased = (Double(amount) / 1000) * costPer1000
		newStock?.spent = costPerAmountPurchased
	}
	
	// If any of the rows are selected the keyboard is dismissed along with first responder.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		view.endEditing(true)
		
		// Dismiss Keyboard after selection is changed
		if indexPath != IndexPath(row: 0, section: 0){
			switch indexPath {
				default:
				stockName.resignFirstResponder()
			}
		}
		
	}
	
	/// Executes when the user uses a primary action. In this case that would be hitting `return`.
	/// - Parameter sender: Originating textField
	@IBAction func moveToNextField(_ sender: UITextField){
		
		let senderTag = sender.tag
		switch senderTag {
			case 1:
				costPer1000Sheets.becomeFirstResponder()
			case 2:
				initialAmount.becomeFirstResponder()
			case 3:
				recommendedAmount.becomeFirstResponder()
			case 4:
				colorTextField.becomeFirstResponder()
			case 5:
				colorTextField.resignFirstResponder()
				if saveButton.isEnabled {
					performSegue(withIdentifier: "done", sender: sender)
			}
			default:
				break
		}
		
	}
	
	/// Checks sender to determine what properties to update. This method
	/// - Parameter sender: Tells the method which field the user is currently updating.
	@IBAction func nameUpdate(_ sender: UITextField) {
		
		switch sender.tag {
			case 1:
				guard let stockName = stockName.text else {return}
				// Initialized with Stock(_ name:) Sorry, I see how not having an external parameter name here can be confusing in retrospect.
				let name = Stock(stockName)
				updateNewStock(name)
			case 2:
				guard let costPer100 = costPer1000Sheets.text else {return}
				// Stock does not have initalizers for this property and that's why it was assigned directly to it like this. This should probably be revised so that the aforementioned protection method can recieve this value properly.
				guard let cost = Double(costPer100) else {return}
				newStock?.cost = cost
			case 3:
				guard let initialAmount = initialAmount.text, let amount = Int(initialAmount) else {return}
				//TODO: Need to added external names for parameters.
				let startingAmount = Stock(nil, nil, nil, amount, nil, nil)
				updateNewStock(startingAmount)
			case 4:
				// Unwraps the text and converts it into an Int.
				guard let recommendedAmount = recommendedAmount.text, let amount = Int(recommendedAmount) else {return}
				let recommended = Stock(nil, nil, nil, nil, amount, nil)
				updateNewStock(recommended)
			case 5:
				guard let color = colorTextField.text else {return}
				//FIXME: This needs to be corrected and added to updateNewStock(_:)
				newStock?.color = color
			
			default:
				break
		}
		// Verifies every property within our object before allowing user to submit their input.
		if newStock?.name != nil && newStock?.name != "" && newStock?.cost != nil && newStock?.amount != nil && newStock?.recommendedAmount != nil && newStock?.color != nil && newStock?.color != "" && newStock?.parentSheetSize != nil && newStock?.weight != nil && newStock?.vender != nil {
			setSpentAmount()
			saveButton.isEnabled = true
		}else{
			saveButton.isEnabled = false
		}
	}
	
}

//MARK: Navigation
extension NewStock_TableViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let identifier = "done"
		if segue.identifier == identifier {
			let destination = segue.destination as! InventoryTracker_CollectionViewController
			guard let amount = newStock?.amount, let recommendedAmount = newStock?.recommendedAmount else {return}
			
			let percentObject = Stock(amount, recommendedAmount)
			// Sets the amount spent for the initial amount of good purchased.
			newStock?.percentRemaining = percentObject.percentRemaining
			guard let stock = newStock else {return}
			destination.stock?.append(stock)
		}
	}
	
	@IBAction func unwindToNewStock(_ unwindSegue: UIStoryboardSegue) {
		
	}
}
