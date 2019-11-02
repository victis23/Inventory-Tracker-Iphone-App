//
//  NewOrder_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class NewOrder_TableViewController: UITableViewController, UITextFieldDelegate {
	
	private struct SegueKeys :Hashable {
		static var save = "newOrderToMain"
	}
	
	@IBOutlet weak var currentAmount: UILabel!
	@IBOutlet weak var orderAmount: UITableViewCell!
	@IBOutlet weak var neededAmountTextField: UITextField!
	@IBOutlet weak var submitButton :UIButton!
	@IBOutlet weak var shortSide : UITextField!
	@IBOutlet weak var longSide : UITextField!

	var stockObject : Stock!
	var stockArray : [Stock] = []
	var indexPath :IndexPath!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		setControllerTitle()
		setupSubmitButtonAsthetics()
		amountLabelText(stockObject)
		tableView.keyboardDismissMode = .interactive
		
    }
	
	func setControllerTitle(){
		guard let weight = stockObject.weight else {return}
		self.title = "New Order of \(weight.rawValue)"
	}
	
	func setupSubmitButtonAsthetics(){
		submitButton.layer.cornerRadius = 10
		shortSide.layer.cornerRadius = 10
		longSide.layer.cornerRadius = 10
		neededAmountTextField.layer.cornerRadius = 10
		shortSide.placeholder = " Width"
		longSide.placeholder = " Length"
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
		var isError = false
		
		guard let neededAmountForNewOrder = neededAmountTextField.text, let neededAmountAsInteger = Double(neededAmountForNewOrder), let shortEdge = shortSide.text, let longEdge = longSide.text else {return}
		guard let doubleShortEdge = Double(shortEdge), let doubleLongEdge = Double(longEdge) else {return}
		
		// handles error that was thrown in the model method
		do {
			try stockObject.performCalculations(incomingAmount: neededAmountAsInteger, shortEdge: doubleShortEdge, longEdge: doubleLongEdge)
		}catch DivisionError.noValueResultingInDivisionByZeroError {
			isError = true
		}catch{}
		
		if !isError  {
			currentAmount.text = "\(stockObject.amount!)"
			stockObject.setPercentageAmount()
			print("******Updated Model******* \(stockObject!)")
			Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
				self.performSegue(withIdentifier: SegueKeys.save, sender: sender)
			}
		}else{
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


