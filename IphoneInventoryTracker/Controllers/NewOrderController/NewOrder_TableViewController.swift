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
		guard let neededAmountForNewOrder = neededAmountTextField.text, let neededAmountAsInteger = Double(neededAmountForNewOrder), let shortEdge = shortSide.text, let longEdge = longSide.text else {return}
		guard let doubleShortEdge = Double(shortEdge), let doubleLongEdge = Double(longEdge) else {return}
		
		stockObject.performCalculations(incomingAmount: neededAmountAsInteger, shortEdge: doubleShortEdge, longEdge: doubleLongEdge)
		currentAmount.text = "\(stockObject.amount!)"
		
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
			self.performSegue(withIdentifier: SegueKeys.save, sender: sender)
		}
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


