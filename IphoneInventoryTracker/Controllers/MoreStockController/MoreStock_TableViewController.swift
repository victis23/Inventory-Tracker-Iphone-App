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
	
	
	//MARK: IBActions
	

	@IBAction func submitButtonTapped(_ sender: Any) {
		guard let amount2 = newAmount.text, let newAmount = Int(amount2), let oldAmount = incomingStock.amount else {return}
		incomingStock?.amount = newAmount + oldAmount
		view.endEditing(true)
		
		guard let amount = incomingStock?.amount else {return}
		amountLabel.text = String(amount)
		incomingStock?.setPercentageAmount()
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
