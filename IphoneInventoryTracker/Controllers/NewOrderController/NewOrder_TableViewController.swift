//
//  NewOrder_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class NewOrder_TableViewController: UITableViewController, UITextFieldDelegate {
	//MARK: Key
	private struct SegueKeys :Hashable {
		static var save = "newOrderToMain"
	}
	// MARK: IBOutlets
	@IBOutlet weak var currentAmount: UILabel!
	@IBOutlet weak var orderAmount: UITableViewCell!
	@IBOutlet weak var neededAmountTextField: UITextField!
	@IBOutlet weak var submitButton :UIButton!
	@IBOutlet weak var shortSide : UITextField!
	@IBOutlet weak var longSide : UITextField!
	//MARK: Class Properties
	var stockObject : Stock!
	var stockArray : [Stock] = []
	var indexPath :IndexPath!
	
	//MARK: State
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubmitButtonAsthetics()
		amountLabelText(stockObject)
		tableView.keyboardDismissMode = .interactive
	}
	/// Sets all of the Asthetics for the contoller's views.
	func setupSubmitButtonAsthetics(){
		guard let weight = stockObject.weight else {return}
		self.title = "New Order of \(weight.rawValue)"
		submitButton.layer.cornerRadius = 10
		shortSide.layer.cornerRadius = 10
		longSide.layer.cornerRadius = 10
		neededAmountTextField.layer.cornerRadius = 10
		shortSide.placeholder = " Width"
		longSide.placeholder = " Length"
	}
	
	// Gets called from InventoryTracker controller when the user has a new order that will update the incoming model's properties.
	func setModelForController(_ model: Stock){
		stockObject = model
	}
	
	/// Updates the text property for `currentAmount` label.
	/// - Parameter model: Object passed into memory from `setModelForController(_:)`
	/// - Important: The reason why this method is seperate from the aforementioned is because we cannot assign a value to the labels before they are loaded into memory. The aforementioned is called prior to the view being loaded into memory.
	func amountLabelText(_ model :Stock){
		currentAmount.text = String(model.amount!)
	}
	//MARK: IBActions
	
	@IBAction func tappedSubmitButton(_ sender: UIButton){
		var isError = false
		//Unwraps incoming text values.
		guard let neededAmountForNewOrder = neededAmountTextField.text, let neededAmountAsInteger = Double(neededAmountForNewOrder), let shortEdge = shortSide.text, let longEdge = longSide.text else {return}
		guard let doubleShortEdge = Double(shortEdge), let doubleLongEdge = Double(longEdge) else {return}
		// Handles error that was thrown in the model method.
		do {
			try stockObject.performCalculations(incomingAmount: neededAmountAsInteger, shortEdge: doubleShortEdge, longEdge: doubleLongEdge)
		}catch DivisionError.noValueResultingInDivisionByZeroError {
			isError = true
		}catch{}
		// If there are no errors.
		if !isError  {
			currentAmount.text = "\(stockObject.amount!)"
			stockObject.setPercentageAmount()
			Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
				self.performSegue(withIdentifier: SegueKeys.save, sender: sender)
			}
		}else{
			// If there is an error, user will get an alert, and all values will be reset.
			let errorAlert = UIAlertController(title: "Wrong Size!", message: "The size of the needed sheet must be smaller than or equal to the actual sheet", preferredStyle: .alert)
			let okButton = UIAlertAction(title: "Ok", style: .default) { (alerthandler) in
				self.shortSide.text = nil
				self.shortSide.becomeFirstResponder()
				self.longSide.text = nil
				self.neededAmountTextField.text = nil
			}
			errorAlert.addAction(okButton)
			present(errorAlert, animated: true) {
			}
		}
	}
	
	//MARK: TableView Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		view.endEditing(true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	//MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destinationController = segue.destination as? InventoryTracker_CollectionViewController else {return}
		
		guard let destinationObject = destinationController.stock else {return}
		
		indexPath = destinationController.dataSource.indexPath(for: stockObject)
		
		stockArray = destinationObject
		stockArray.remove(at: indexPath.item)
		stockArray.insert(stockObject, at: indexPath.item)
		destinationController.stock = stockArray
	}
}


