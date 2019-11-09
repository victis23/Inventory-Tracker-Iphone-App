//
//  PaperCalculatorViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class PaperCalculatorViewController: UITableViewController {
	
	//MARK: IBOUTLETS
	
	@IBOutlet weak var mainStack: UIStackView!
	@IBOutlet weak var parentSheetStack: UIStackView!
	@IBOutlet weak var childSheetStack: UIStackView!
	@IBOutlet weak var submitButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupAesthetic()
    }
	
	func setupAesthetic(){
		tableView.keyboardDismissMode = .interactive
		submitButton.layer.cornerRadius = 10
		submitButton.setTitle("Submit", for: .normal)
	}
	
	@IBAction func tappedSubmitButton(_ sender: Any) {
		parentSheetStack.isHidden = true
		childSheetStack.isHidden = true
	}
}
