//
//  VenderList_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//


import UIKit

/// Performs the same function as `ViewVendersTableViewController.swift` however this controller is only accessable through the `NewStock` controller.
class VenderList_TableViewController: UITableViewController {
	
	//Internal Keys
	fileprivate struct Keys {
		//Segue
		static var returnHomeWithVender = "goHomeVender"
		//Segue
		static var venderInfo = "venderContactinfo"
		//TableView Cell
		static var cellKey = "vender"
	}
	
	// Section Selection For Tableview.
	enum Section {
		case main
	}
	
	//MARK: Local Properties
	
	// Item selected from list to be transfered in unwind.
	fileprivate var selectedVender : Vendor!
	//DataSource Object — Intialized to Nil
	private var dataSource : UITableViewDiffableDataSource<Section, Vendor>! = nil
	//Used in tableView as source of data.
	//Snapshop created on initialization everytime.
	
	var venders : [Vendor] = [] {
		didSet {
			snapShot(with: venders)
		}
	}
	
	//MARK: State
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// Methods placed here to avoid running dataSource before tableview is set in UIWindow.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setDataSource()
		initialSetup()
	}
	
	//MARK: Methods
	/// Checks disk for saved inventory.
	/// If inventory list exists this method will decode the data and extract each inventory object's vendor object.
	/// The extracted vendor objects are then assigned to the local `venders` property.
	func initialSetup(){
		guard let stocks : [Stock] = Stock.decode() else {return}
		var allVenders : [Vendor] = []
		stocks.forEach({allVenders.append($0.vender!)})
		venders = allVenders
	}
	
	/// Creates the snapshot datasource for local tableview controller.
	/// - Parameter venders: local list of vendors.
	func snapShot(with venders: [Vendor]){
		var snapShot = NSDiffableDataSourceSnapshot<Section,Vendor>()
		snapShot.appendSections([.main])
		snapShot.appendItems(venders, toSection: .main)
		dataSource?.apply(snapShot, animatingDifferences: true)
	}
	
	//MARK: Navigation
	@IBAction func unwindToVenders(_ unwindSegue: UIStoryboardSegue) {
		// If the originating view controller is AddVendersTableViewController than we append it's vendors to our local venders array.
		guard let sourceViewController = unwindSegue.source as? AddVendersTableViewController else {return}
		venders.append(sourceViewController.vender!)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Keys.returnHomeWithVender {
			let destination = segue.destination as! NewStock_TableViewController
			// We create a new stock object that only has a value on its vender property.
			let model = Stock(nil, nil, nil, nil, nil, selectedVender)
			// Calls updateNewStock(_:) The model checks through each property and determines where to place the extracted data from incoming models.
			destination.updateNewStock(model)
			guard let vender = selectedVender else {return}
			// Sets destination label text property to current vender object's name property value.
			destination.venderLabel.text = vender.name
		}
		// If segue destination is the vendor contact page set its contactInformation property to the vender selected by the user. This only happens if the user selects the option to view the venders contact info.
		if segue.identifier == Keys.venderInfo {
			let destination = segue.destination as! VenderContactInfo_TableViewController
			destination.contactInformation = selectedVender
		}
	}
}

extension VenderList_TableViewController {
	
	/// Gets called when user selects option to access vendor contact information sheet.
	/// Method is called by the tableview on tableView(_: didSelectRowAt:).
	/// - Parameter :
	/// 	- vender: Local vendor object.
	/// 	#Internal Objects
	/// 	- saveVenderSelection : Performs the segue that saves selected vender to `stock` object, and deallocates current controller.
	///		- getInformation : Performs segue that takes user to vendor contact page.
	///		- cancel : Dismisses option menu.
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
}

//MARK: TableView DataSource & Delegate Methods.

extension VenderList_TableViewController {
	
	/// Sets up tableView controller cell
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
	
	// Presents options to user for selected vendor object and passes the object at index to be used as sender in whatever segue the user chooses.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let model = dataSource.itemIdentifier(for: indexPath) else {return}
		getVenderContactInfo(model)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}


