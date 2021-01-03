//
//  ExtensionInventoryTrackerViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/1/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

extension InventoryTracker_CollectionViewController: UISearchBarDelegate {
	
	/// - Description: Sorts values in `stock` collection and creates a temporary array of stock objects that are used in `createSnapShot(_: )` when called by `searchBar(_: textDidChange: )` This method is not case sensative.
	/// - Parameter string: Search term entered by user into `searchField`
	/// - Important: This method sorts based on the following value properties:
	/// 	- name
	///		- weight
	///		- color
	///		- parentSheetSize
	func filteredStocks(with string: String) -> [Stock] {
		let privateStocks = stock?.filter( { (item) -> Bool in
			if (item.name?.lowercased().contains(string.lowercased()))! || item.weight!.rawValue.lowercased().contains(string.lowercased()) ||
				item.color!.lowercased().contains(string.lowercased()) ||
				item.parentSheetSize!.rawValue.lowercased().contains(string.lowercased()) {
				return true
			}else {
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
	
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		
		// Notifies observer that keyboard is now visable on screen.
		NotificationCenter.default.addObserver(self, selector: #selector(setNewViewHeight(with: )), name: hide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(setNewViewHeight(with: )), name: show, object: nil)
	}
	
	
	@objc func setNewViewHeight(with notification: Notification) {
		
		guard let originalFrame = viewFrameHeight else {return}
		
		let keyboardData = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		let keyboardFrame = keyboardData?.cgRectValue
		guard let keyboardHeight = keyboardFrame?.height else {return}
		
		
		switch notification.name {
			case UIResponder.keyboardDidShowNotification:
				// Contracts scroll view frame to size of view minus keyboard and then sets content size to size of main view.
				scrollView.frame.size.height = originalFrame - keyboardHeight
				scrollView.contentSize.height = originalFrame
			default:
				
				//Returns Views To default size.
				scrollView.frame.size.height = originalFrame
				scrollView.contentSize.height = originalFrame
		}
		// Stops observing...
		NotificationCenter.default.removeObserver(self, name: hide, object: nil)
		NotificationCenter.default.removeObserver(self, name: show, object: nil)
	}
	
}

