//
//  ViewVendersTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/3/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Displays list of vendors to user on a seperate page.
/// - Important: This is the page that is displayed from the tab view.
class ViewVendersTableViewController: UITableViewController {
	
	//Sections
	enum Sections {
		case main
	}
	
	//MARK: Properties
	
	// Holds list of local vender objects.
	var venders : [Vendor]? = []
	
	// Sets diffableDataSource property for controller.
	var dataSource : UITableViewDiffableDataSource<Sections,Vendor>! = nil
	
	//MARK: State
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// Placed here to avoid warning about placing content on tableview before it has been applie to UIWindow.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setDataSource()
		getVenderList()
	}
	
	//MARK:  Methods
	
	/// Removes all existing vendors from venders array on every itirration.
	/// - Important : `.removeAll()` is a must! Otherwise we get double items in list.
	///	- Note: Only stocks from saved Stock objects will appear in the list. Our initial snapshot is based only on saved items.
	func getVenderList(){
		venders?.removeAll()
		guard let stocks : [Stock] = Stock.decode() else {
			presentAlert()
			return}
		
		// Each vendor object is extracted here and placed into our local object.
		stocks.forEach({
			guard let vender = $0.vender else {return}
			venders?.append(vender)
		})
		
		guard let vendors = venders else {return}
		createUniqueList(with: vendors)
	}
	
	/// If the user hasnt added any items this method is evaluated and will send the user either to the main screen if they cancel or to the add stock screen if they choose to do so.
	func presentAlert(){
		let alert = UIAlertController(title: "No Inventory", message: "You have not added inventory to your list yet.", preferredStyle: .alert)
		let add = UIAlertAction(title: "ADD", style: .default) { [weak self](bool) in
			self?.performSegue(withIdentifier: "addStock", sender: nil)
		}
		let cancel = UIAlertAction(title: "Ignore", style: .destructive) { [weak self](bool) in
			self?.dismiss(animated: true, completion: nil)
		}
		alert.addAction(add)
		alert.addAction(cancel)
		present(alert, animated: true)
	}
	
	/// Removes duplicates using domain & range mathematical principal.
	/// - Note:
	///	-	Domain = `Vendor.Name`
	/// -	Range =  `Vendor`
	func createUniqueList(with vendors: [Vendor]){
		var list : [String:Vendor] = [:]
		vendors.forEach({
			list[$0.name] = $0
		})
		let uniqueVendors = list.map({$1})
		setSnapShot(from: uniqueVendors)
	}
	
	// Local vendor object `venders` is only ever used for our variable in this method.
	func setSnapShot(from localVenderList: [Vendor]){
		var snapShot = NSDiffableDataSourceSnapshot<Sections, Vendor>()
		snapShot.appendSections([.main])
		snapShot.appendItems(localVenderList, toSection: .main)
		dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
	}
	
	//MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "info" {
			let controller = segue.destination as! VenderContactInfo_TableViewController
			controller.contactInformation = sender as? Vendor
		}
		if segue.identifier == "addStock" {
			let navigationController = segue.destination as! UINavigationController
			
			let controller = navigationController.topViewController as! InventoryTracker_CollectionViewController
			controller.passthroughSegue()
		}
	}
}

//MARK: - TableView DataSource & Delegates
extension ViewVendersTableViewController {
	
	func setDataSource(){
		dataSource = UITableViewDiffableDataSource<Sections,Vendor>(tableView: tableView, cellProvider: { (tableView, indexPath, venders) -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "venders", for: indexPath)
			cell.textLabel?.text = venders.name
			cell.textLabel?.font = .systemFont(ofSize: 40, weight: .ultraLight)
			cell.textLabel?.textColor = .label
			return cell
			
		})
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let object = dataSource.itemIdentifier(for: indexPath) else {return}
		performSegue(withIdentifier: "info", sender: object)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
}



