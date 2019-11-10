//
//  MoreStock_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/14/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class MoreStock_TableViewController: UITableViewController {
	
	//MARK: Keys
	// Keys for Segues
	private struct SegueKeys {
		static var home = "home"
	}
	
	// MARK: IBOutlets
	
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var newAmount: UITextField!
	
	//MARK: Class Properties
	
	var incomingStock : Stock!
	var indexPath : IndexPath?
	
	//MARK: State

    override func viewDidLoad() {
        super.viewDidLoad()
		setAmountLabel()
		setControllerTitle()
		setButtonAesthetics()
		tableView.keyboardDismissMode = .interactive
    }
	
	/// Assigns incoming instance of `Stock` to local property.
	/// - Note: This method is called duing segue to this view.
	/// - Parameter incomingModel: Recieved Stock Object from `InventoryTracker_CollectionViewController.swift`.
	func setModelForController(_ incomingModel : Stock){
		incomingStock = incomingModel
	}
	
	/// Updates  local variable with the value of amount property from incoming `Stock` object.
	/// Assigns this value to `text` property of amountLabel.
	func setAmountLabel(){
		guard let amount = incomingStock?.amount else {return}
		amountLabel.text = String(amount)
	}
	
	/// Sets title that will be displayed in navigation controller.
	func setControllerTitle(){
		self.title = "Add Stock For \(incomingStock?.name ?? "Inventory List")"
	}
	
	/// Modifies visual look for the view upon `viewDidLoad()`.
	func setButtonAesthetics(){
		submitButton.layer.cornerRadius = 10
		submitButton.setTitle("Update", for: .normal)
		newAmount.layer.cornerRadius = 10
		newAmount.placeholder = " Amount Added"
	}
	
	/// Takes in the new amount of stock being added to inventory and calculates the cost per 1000 pieces.
	/// - Returns: This is the integer total of new stock being added to inventory.
	func updateSpentAmount(with stockAmount: Int)->Double {
		guard let cost = incomingStock.cost else {return 0}
		let pricePerNewAmount = Double(stockAmount) / 1000
		let costToAdd = pricePerNewAmount * cost
		return costToAdd
	}
	
	
	//MARK: IBActions
	
	@IBAction func submitButtonTapped(_ sender: Any) {
		// Unwraps values and assigns the new amount added by user to the current total.
		// newAmount : The new amount added by user. —> amount2 is this value as a string.
		// oldAmount : This is the current amount of inventory.
		guard let amount2 = newAmount.text, let newAmount = Int(amount2), let oldAmount = incomingStock.amount else {return}
		incomingStock?.amount = newAmount + oldAmount
		view.endEditing(true)
		guard let amount = incomingStock?.amount, let spentTotal = incomingStock.spent else {return}
		amountLabel.text = String(amount)
		// Uses new values to update percent of inventory in comparison to recommended amount.
		incomingStock?.setPercentageAmount()
		// Updates the total amount spent by adding to the original amount.
		// The Amount used needs to be the amount prior to it being added to the total!
		incomingStock.spent = updateSpentAmount(with: newAmount) + spentTotal
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
			self.performSegue(withIdentifier: SegueKeys.home, sender: self.incomingStock)
		}
	}
	//MARK: TableView Delegate
	
	// Does nothing other than deselecting the current cell and hiding keyboard. The purpose of this method is primarily just to hide the keyboard.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		view.endEditing(true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: Navigation
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueKeys.home {
			guard let homeController = segue.destination as? InventoryTracker_CollectionViewController else {return}
			// Gets indexPath using model identifier.
			indexPath = homeController.dataSource.indexPath(for: incomingStock)
			// Creates a empty collection that will be holding the collect of stock that we will be appending to.
			var localStocks :[Stock] = []
			// Unwrapping collection of Stock from InventoryTracker...
			guard let externalStock = homeController.stock else {return}
			// Assigns this collect to local instance.
			localStocks = externalStock
			// If statement is just a checker - Not Required.
			// Removes the old value for the specified IndexPath, then assigns our local value.
			// If the old value is not removed you will be recieving a non-unique identifier error.
			if indexPath?.item != nil {
				localStocks.remove(at: indexPath!.item)
				localStocks.insert(incomingStock, at: indexPath!.item)
			}
			// Updates the collection of stock on InventoryTracker... with the local value.
			homeController.stock = localStocks
		}
	}
}
