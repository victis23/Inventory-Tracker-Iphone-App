//
//  ExtensionInventoryTrackerViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/1/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import Combine

extension InventoryTracker_CollectionViewController : UISearchBarDelegate {
	
	/// - Description: Sorts values in `stock` collection and creates a temporary array of stock objects that are used in `createSnapShot(_:)` when called by `searchBar(_:textDidChange:)` This method is not case sensative.
	/// - Parameter string: Search term entered by user into `searchField`
	/// - Important: This method sorts based on the following value properties:
	/// 	- name
	///		- weight
	///		- color
	///		- parentSheetSize
	func filteredStocks(with string: String)-> [Stock]{
		let privateStocks = stock?.filter({ (item) -> Bool in
			if (item.name?.lowercased().contains(string.lowercased()))! || item.weight!.rawValue.lowercased().contains(string.lowercased()) ||
				item.color!.lowercased().contains(string.lowercased()) ||
				item.parentSheetSize!.rawValue.lowercased().contains(string.lowercased()){
				return true
			}else{
				return false
			}
		})
		guard let stocks = privateStocks else {fatalError()}
		return stocks
	}
	
	// Updates snapshot with temporary value based on the users input.
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		switch searchText {
			case "":
				createSnapShot(stock)
			default:
				// This value is never modified by the user this is used as a read-only value. Attempting to modify this object causes a non-unique identifier error.
				createSnapShot(filteredStocks(with: searchText))
		}
	}
	
	// Dismiss the keyboard when the user submits their query.
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchField.resignFirstResponder()
	}
}
