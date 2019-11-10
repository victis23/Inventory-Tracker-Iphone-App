//
//  CostOfSpentGoodsTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class CostOfSpentGoodsTableViewController: UITableViewController {
	
	enum Section {
		case main
	}
	
	struct Keys {
		static var uniqueCellIdentifer = "cell"
	}


	
	var dataSource : UITableViewDiffableDataSource<Section,Stock>? = nil
	var stock : [Stock]? = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		retrieveInventoryListFromFile()
		setupDataSource()
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		createSnapShot()
	}
	
	func retrieveInventoryListFromFile(){
		stock = Stock.decode() as [Stock]?
	}
	
	func setupDataSource(){
		dataSource = UITableViewDiffableDataSource<Section,Stock>(tableView: tableView, cellProvider: { (tableView, indexPath, stock) -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.uniqueCellIdentifer, for: indexPath) as! CostTableViewCell
			
			cell.nameLabel.text = stock.name
			guard let spent = stock.spent else {fatalError()}
			
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
