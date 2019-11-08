//
//  VenderList_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//


import UIKit

class VenderList_TableViewController: UITableViewController {
	
	fileprivate struct Keys {
		static var returnHomeWithVender = "goHomeVender"
		static var venderInfo = "venderContactinfo"
		static var cellKey = "vender"
	}
	
	enum Section {
		case main
	}
	
	//MARK: ... Variable Declarations
	
	private var dataSource : UITableViewDiffableDataSource<Section, Vendor>! = nil
	
	var venders : [Vendor] = [] {
		didSet {
			snapShot(with: venders)
		}
	}
	
	fileprivate var selectedVender : Vendor!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//		setDataSource()
		//		initialSetup()
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setDataSource()
		initialSetup()
	}
	deinit {
		print("Vender List Is Killed")
	}
	func initialSetup(){
		guard let stocks : [Stock] = Stock.decode() else {return}
		var allVenders : [Vendor] = []
		stocks.forEach({allVenders.append($0.vender!)})
		venders = allVenders
	}
	func snapShot(with venders: [Vendor]){
		var snapShot = NSDiffableDataSourceSnapshot<Section,Vendor>()
		snapShot.appendSections([.main])
		snapShot.appendItems(venders, toSection: .main)
		dataSource?.apply(snapShot, animatingDifferences: true)
	}
	
	func setDataSource(){
		dataSource = UITableViewDiffableDataSource<Section,Vendor>(tableView: tableView, cellProvider: { (tableView, indexPath, vender) -> UITableViewCell? in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cellKey, for: indexPath) as! VenderCell_TableViewCell
			
			cell.companyName.text = vender.name
			return cell
		})
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	//	private class Datasource : UITableViewDiffableDataSource<Section,Vender> {
	//	}
	
	@IBAction func unwindToVenders(_ unwindSegue: UIStoryboardSegue) {
		guard let sourceViewController = unwindSegue.source as? AddVendersTableViewController else {return}
		venders.append(sourceViewController.vender!)
	}
	
}



extension VenderList_TableViewController {
	
	
	
	func getVenderContactInfo(_ vender:Vendor){
		let alertViewController = UIAlertController(title: "Supplier Information", message: "Select GET INFO to view supplier information.", preferredStyle: .actionSheet)
		let saveVenderSelection = UIAlertAction(title: "Save", style: .default) { (bool) in
			self.selectedVender = vender
			self.performSegue(withIdentifier: Keys.returnHomeWithVender, sender: self)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		let getInformation = UIAlertAction(title: "Get Info", style: .default) { (bool) in
			self.selectedVender = vender
			self.performSegue(withIdentifier: Keys.venderInfo, sender: self)
		}
		let options : [UIAlertAction] = [saveVenderSelection, getInformation, cancel]
		options.forEach {alertViewController.addAction($0)}
		alertViewController.preferredAction = saveVenderSelection
		present(alertViewController, animated: true, completion: nil)
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let model = dataSource.itemIdentifier(for: indexPath) else {return}
		getVenderContactInfo(model)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}

// MARK: Navigation

extension VenderList_TableViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Keys.returnHomeWithVender {
			let destination = segue.destination as! NewStock_TableViewController
			let model = Stock(nil, nil, nil, nil, nil, selectedVender)
			destination.updateNewStock(model)
			guard let vender = selectedVender else {return}
			destination.venderLabel.text = vender.name
		}
		
		if segue.identifier == Keys.venderInfo {
			let destination = segue.destination as! VenderContactInfo_TableViewController
			destination.contactInformation = selectedVender
		}
	}
	
}

