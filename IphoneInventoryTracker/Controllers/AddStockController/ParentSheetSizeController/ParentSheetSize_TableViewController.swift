//
//  ParentSheetSize_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class ParentSheetSize_TableViewController: UITableViewController {
	
	private struct Keys {
		static var paper = "paper"
	}
	
	private enum Section {
		case paper
		case envelopes
	}
	
	var defaultStocks = [Stock]
	

	private var dataSource :Datasource!

    override func viewDidLoad() {
        super.viewDidLoad()
		setDataSource()
    }
	
	func setDataSource(){
		dataSource = Datasource(tableView: tableView, cellProvider: { (tableView, indexPath, parentSizeObject) -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.paper, for: indexPath)
		
			return cell
		})
	}
	
	
	private class Datasource : UITableViewDiffableDataSource<Section,Stock>{
		
		override func numberOfSections(in tableView: UITableView) -> Int {
			return 2
		}
	}
	
}

