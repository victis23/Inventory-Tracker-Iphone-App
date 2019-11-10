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
	}
	
	//MARK: Class Properties
	
	var dataSource : UITableViewDiffableDataSource<Section,Stock>? = nil
	var stock : [Stock]? = []
	
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
		stock = Stock.decode() as [Stock]?
	}
	
	//MARK: - TableView DataSource & Delegate Methods.
	
	func setupDataSource(){
		dataSource = UITableViewDiffableDataSource<Section,Stock>(tableView: tableView, cellProvider: { (tableView, indexPath, stock) -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.uniqueCellIdentifer, for: indexPath) as! CostTableViewCell
			
			cell.nameLabel.text = stock.name
			guard let spent = stock.spent else {fatalError()}
			
			// Adds two decimal points to value. $0.00
			cell.costLabel.text = "$\(String(format: "%.2f", spent))"
			return cell
		})
	}
	
	func createSnapShot(){
		guard let stock = stock else {return}
		var snapShot = NSDiffableDataSourceSnapshot<Section,Stock>()
		snapShot.appendSections([.main])
		snapShot.appendItems(stock, toSection: .main)
		dataSource?.apply(snapShot, animatingDifferences: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
}
