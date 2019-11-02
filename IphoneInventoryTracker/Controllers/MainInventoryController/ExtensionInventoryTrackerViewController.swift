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
	
//	func createObserver(with observerItem : NSObject){
//		guard let object = observerItem as? UISearchBar else {return}
//		let item = $searchResult.sink { (string) in
//			print(string)
//		}
//		item.cancel()
//	}
	
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
	
	// Easy way
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		switch searchText {
			case "":
				createSnapShot(stock)
			default:
				createSnapShot(filteredStocks(with: searchText))
		}
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchField.resignFirstResponder()
	}
}
