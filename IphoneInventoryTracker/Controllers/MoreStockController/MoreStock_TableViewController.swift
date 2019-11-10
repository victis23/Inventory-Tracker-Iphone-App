//
//  MoreStock_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/14/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class MoreStock_TableViewController: UITableViewController {
	
	private struct SegueKeys {
		static var home = "home"
	}
	
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var newAmount: UITextField!
	var incomingStock : Stock!
	var indexPath : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
		setAmountLabel()
		setControllerTitle()
		setButtonAesthetics()
		tableView.keyboardDismissMode = .interactive
    }
	
	func setModelForController(_ incomingModel : Stock){
		incomingStock = incomingModel
	}
	func setAmountLabel(){
		guard let amount = incomingStock?.amount else {return}
		amountLabel.text = String(amount)
	}
	func setControllerTitle(){
		self.title = "Add Stock For \(incomingStock?.name ?? "Inventory List")"
	}
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
		guard let amount2 = newAmount.text, let newAmount = Int(amount2), let oldAmount = incomingStock.amount else {return}
		incomingStock?.amount = newAmount + oldAmount
		view.endEditing(true)
		
		guard let amount = incomingStock?.amount, let spentTotal = incomingStock.spent else {return}
		amountLabel.text = String(amount)
		incomingStock?.setPercentageAmount()
		// Updates the total amount spent by adding to the original amount.
		incomingStock.spent = updateSpentAmount(with: amount) + spentTotal
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
			self.performSegue(withIdentifier: SegueKeys.home, sender: self.incomingStock)
		}
	}
	//MARK: TableView Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		view.endEditing(true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueKeys.home {
			guard let homeController = segue.destination as? InventoryTracker_CollectionViewController else {return}
			
			indexPath = homeController.dataSource.indexPath(for: incomingStock)
			
			var localStocks :[Stock] = []
			guard let externalStock = homeController.stock else {return}
			
			localStocks = externalStock
			if indexPath?.item != nil {
				localStocks.remove(at: indexPath!.item)
				localStocks.insert(incomingStock, at: indexPath!.item)
			}
			homeController.stock = localStocks
		}
	}
}
