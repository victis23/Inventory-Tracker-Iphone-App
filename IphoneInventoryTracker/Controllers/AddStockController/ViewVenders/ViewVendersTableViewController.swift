//
//  ViewVendersTableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/3/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import Combine

class ViewVendersTableViewController: UITableViewController, ObservableObject {
	
	enum Sections {
		case main
	}
	var venders : [Vendor]? = []

	var dataSource : UITableViewDiffableDataSource<Sections,Vendor>! = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setDataSource()
		getVenderList()
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		getVenderList()
	}
	
	func getVenderList(){
		venders?.removeAll()
		guard let stocks : [Stock] = Stock.decode() else {return}
		stocks.forEach({
			guard let vender = $0.vender else {return}
			venders?.append(vender)
		})
		guard let venders = venders else {return}
		setSnapShot(from: venders)
	}
	func setSnapShot(from localVenderList: [Vendor]){
		var snapShot = NSDiffableDataSourceSnapshot<Sections, Vendor>()
		snapShot.appendSections([.main])
		snapShot.appendItems(localVenderList, toSection: .main)
		dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
	}
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "info" {
			let controller = segue.destination as! VenderContactInfo_TableViewController
			controller.contactInformation = sender as? Vendor
		}
	}
}
