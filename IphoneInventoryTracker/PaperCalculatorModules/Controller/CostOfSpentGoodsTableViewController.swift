//
//  CostOfSpentGoodsTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Updates and displays the total cost of goods for each item in inventory.
class CostOfSpentGoodsTableViewController: UITableViewController {
	
	//MARK: Local Data types
	
	//Sections used for DataSource.
	enum Section {
		case main
	}
	
	//KEYS
	struct Keys {
		static var uniqueCellIdentifer = "cell"
		static var segueKey = "addStock"
	}
	
	//MARK: Class Properties
	
	var dataSource : DataSource!
	var localStockArray : [Stock]? = []
	var inventoryIsEmpty: Bool = false
	
	//MARK: State
	
	override func viewDidLoad() {
		super.viewDidLoad()
		retrieveInventoryListFromFile()
		setupDataSource()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		createSnapShot()
	}
	
	//MARK: Methods
	
	/// Decodes list of stocks from disk and assigns to local collection.
	/// - Note: Object method returns a generic  <T: Hashable>.
	func retrieveInventoryListFromFile(){
		// Method returns a generic that needs to be specified.
		localStockArray = Stock.decode() as [Stock]?
		// If the user has not added inventory to their list yet a default Stock value is assigned to tableview.
		if localStockArray == nil {
			let nilStock = Stock()
			localStockArray = [nilStock]
			inventoryIsEmpty = true
		}
	}
	
	//MARK: - TableView DataSource & Delegate Methods.
	
	func setupDataSource(){
		
		dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, stock) -> UITableViewCell? in
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.uniqueCellIdentifer, for: indexPath) as! CostTableViewCell
			
			// This is executed if user has not added any inventory to their list.
			guard stock.name != nil else {
				cell.nameLabel.text = stock.errorMessage
				cell.costLabel.text = "ADD"
				cell.costLabel.textColor = .systemBlue
				return cell
			}
			
			
			cell.nameLabel.text = stock.name
			guard let spent = stock.spent else {fatalError()}
			
			// Adds two decimal points to value. $0.00
			cell.costLabel.text = "$\(String(format: "%.2f", spent))"
			return cell
		})
	}
	
	func createSnapShot(){
		guard let stock = localStockArray else {return}
		var snapShot = NSDiffableDataSourceSnapshot<Section,Stock>()
		snapShot.appendSections([.main])
		snapShot.appendItems(stock, toSection: .main)
		dataSource?.apply(snapShot, animatingDifferences: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
	
	class DataSource : UITableViewDiffableDataSource<Section,Stock> {
		override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
			switch section {
				default:
					return "Total Cost Of Item"
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch inventoryIsEmpty {
			case true:
				performSegue(withIdentifier: Keys.segueKey, sender: nil)
						default:
				break
		}
	}
}

extension CostOfSpentGoodsTableViewController {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Keys.segueKey {
			let navigationController = segue.destination as! UINavigationController
			
			let controller = navigationController.topViewController as! InventoryTracker_CollectionViewController
			controller.passthroughSegue()
		}
	}
	
}
