//
//  VenderContactInfo_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class VenderContactInfo_TableViewController: UITableViewController {
	
	@IBOutlet weak var supplierName :UILabel!
	var contactInformation : VenderInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
		supplierName.text = contactInformation.name.rawValue
		
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
	
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }


}
