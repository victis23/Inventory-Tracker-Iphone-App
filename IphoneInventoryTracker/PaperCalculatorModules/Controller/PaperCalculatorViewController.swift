//
//  PaperCalculatorViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import Combine

class PaperCalculatorViewController: UITableViewController {
	
	//MARK: IBOUTLETS
	
	@IBOutlet weak var mainStack: UIStackView!
	@IBOutlet weak var parentSheetStack: UIStackView!
	@IBOutlet weak var longSideParentSheet: UITextField!
	@IBOutlet weak var shortSideParentSheet: UITextField!
	@IBOutlet weak var childSheetStack: UIStackView!
	@IBOutlet weak var shortEndPieceSize: UITextField!
	@IBOutlet weak var longEndPieceSize: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var mainStackCenterXContraint: NSLayoutConstraint!
	@IBOutlet weak var resultsView: UIView!
	@IBOutlet weak var resultsViewCenterXContraint: NSLayoutConstraint!
	
	//MARK: Properties
	var resultsAreVisable = false
	var values : Calculations?
	var textFields : [UITextField?] = []
	//MARK: State
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAesthetic()
	}
	//MARK: Methods
	/// Sets aesthetics that will be visable within the view controller.
	func setupAesthetic(){
		tableView.keyboardDismissMode = .interactive
		submitButton.layer.cornerRadius = 10
		resultsView.layer.cornerRadius = 10
		resultsViewCenterXContraint.constant = -450
		submitButton.setTitle("Submit", for: .normal)
	}
	
	/// Flips back and forth between the main stack and the results views.
	func makeResultsVisable(){
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.mainStackCenterXContraint.constant = 450
			self?.resultsViewCenterXContraint.constant = 0
			self?.submitButton.setTitle("Return", for: .normal)
			self?.initalizeObject()
			// Assigns each text field to the textField property.
			// These need to be placed in the array in this particular order because initalizeObject() will be using them to create our model.
			// 1. shortSideParentSheet
			// 2. longSideParentSheet
			// 3. shortEndPieceSize
			// 4. longEndPieceSize
			self?.textFields = [self?.shortSideParentSheet,self?.longSideParentSheet, self?.shortEndPieceSize, self?.longEndPieceSize]
			//Clears values placed in field by user on each item.
			self?.textFields.forEach({
				$0?.text = ""
			})
			self?.view.layoutIfNeeded()
		}
		resultsAreVisable = !resultsAreVisable
	}
	
	/// Returns view to original view with results view moved off screen.
	func makeViewOriginalView(){
		
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.mainStackCenterXContraint.constant = 0
			self?.resultsViewCenterXContraint.constant = -450
			self?.submitButton.setTitle("Submit", for: .normal)
			self?.view.layoutIfNeeded()
		}
		resultsAreVisable = !resultsAreVisable
	}
	
	/// Creates an ordered collection that will be containing the text value of each UITextField.
	/// Unwraps & converts the text value to a double & appends.
	func initalizeObject(){
		var userInputValues : [Double] = []
		textFields.forEach({
			guard let unamedValue = $0?.text, let numbericValue = Double(unamedValue) else {return}
			userInputValues.append(numbericValue)
		})
		values = Calculations(sParent: userInputValues[0], lParent: userInputValues[1], sPiece: userInputValues[2], lPiece: userInputValues[3])
	}
	
	//MARK: IBACTIONS
	@IBAction func tappedSubmitButton(_ sender: Any) {
		// Evaluates bool for results view.
		switch resultsAreVisable {
			case true:
				makeViewOriginalView()
			default:
				makeResultsVisable()
		}
	}
}
