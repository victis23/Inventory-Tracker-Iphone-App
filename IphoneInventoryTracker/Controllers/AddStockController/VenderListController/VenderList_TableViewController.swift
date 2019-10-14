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
	}
	
	fileprivate var selectedVender : Vender!
	fileprivate var venderInformation : VenderInfo!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	func getVenderContactInfo(_ vender:Vender){
		let alertViewController = UIAlertController(title: "Supplier Information", message: "Select GET INFO to view supplier information.", preferredStyle: .actionSheet)
		let saveVenderSelection = UIAlertAction(title: "Save", style: .default) { (bool) in
			self.selectedVender = vender
			self.performSegue(withIdentifier: Keys.returnHomeWithVender, sender: self)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		let getInformation = UIAlertAction(title: "Get Info", style: .default) { (bool) in
			self.performSegue(withIdentifier: Keys.venderInfo, sender: self)
		}
		let options : [UIAlertAction] = [saveVenderSelection, getInformation, cancel]
		options.forEach {alertViewController.addAction($0)}
		present(alertViewController, animated: true, completion: nil)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return 3
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedRow = indexPath.row
		
		switch selectedRow {
			case 0:
				let vender = Vender.Case
				venderInformation = VenderInfo(name: Vender.Case, address: "3333 N.W. 116th Street, Miami, FL, 33167", phone: "305-681-2273", email: "jciavola@casepaper.com", website: URL(string: "http://www.casepaper.com"))
				getVenderContactInfo(vender)
			case 1:
				let vender = Vender.Veritiv
				venderInformation = VenderInfo(name: Vender.Veritiv, address: "3200 Mercy Dr, Orlando, FL, 32808", phone: "407-521-3090", email: "orlandoVE@veritivcorp.com", website: URL(string: "http://www.veritivcorp.com"))
				getVenderContactInfo(vender)
			case 2:
				let vender = Vender.MacPapers
				venderInformation = VenderInfo(name: Vender.MacPapers, address: "3300 Philips Highway, Jacksonville, FL, 32207", phone: "407-629-5354", email: "cyndy.rosato@macpapers.com", website: URL(string: "http://www.macpapers.com"))
				getVenderContactInfo(vender)
			default:
			break
		}
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
			destination.venderLabel.text = vender.rawValue
		}
		
		if segue.identifier == Keys.venderInfo {
			let destination = segue.destination as! VenderContactInfo_TableViewController
			destination.contactInformation = venderInformation
		}
	}
}

