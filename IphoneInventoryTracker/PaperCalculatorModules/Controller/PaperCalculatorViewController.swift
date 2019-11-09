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
	@IBOutlet weak var longSideResultLabel: UILabel!
	@IBOutlet weak var shortSideResultLabel: UILabel!
	
	
	//MARK: Properties
	var resultsAreVisable = false
	var values : Calculations?
	var textFields : [UITextField?] = []
	//MARK: State
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAesthetic()
		setUpTextFields()
	}
	//MARK: Methods
	/// Sets aesthetics that will be visable within the view controller.
	/// Sets submit button to `DISABLED`
	func setupAesthetic(){
		tableView.keyboardDismissMode = .interactive
		submitButton.layer.cornerRadius = 10
		isSubmitButtonActive(false)
		resultsView.layer.cornerRadius = 10
		resultsViewCenterXContraint.constant = -450
		submitButton.setTitle("Submit", for: .normal)
	}
	
	/// Flips back and forth between the main stack and the results views.
	func makeResultsVisable(){
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.view.endEditing(true)
			self?.mainStackCenterXContraint.constant = 450
			self?.resultsViewCenterXContraint.constant = 0
			self?.submitButton.setTitle("Return", for: .normal)
			self?.initalizeObject()
			//Clears values placed in field by user on each item.
			self?.textFields.forEach({
				$0?.text = ""
			})
			self?.view.layoutIfNeeded()
		}
		resultsAreVisable = !resultsAreVisable
	}
	
	func setUpTextFields(){
		// Assigns each text field to the textField property.
		// These need to be placed in the array in this particular order because initalizeObject() will be using them to create our model.
		// 1. shortSideParentSheet
		// 2. longSideParentSheet
		// 3. shortEndPieceSize
		// 4. longEndPieceSize
		self.textFields = [self.shortSideParentSheet,self.longSideParentSheet, self.shortEndPieceSize, self.longEndPieceSize]
		
		textFields.forEach({
			$0?.delegate = self
		})
	}
	
	/// Returns view to original view with results view moved off screen.
	func makeViewOriginalView(){
		
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.mainStackCenterXContraint.constant = 0
			self?.resultsViewCenterXContraint.constant = -450
			self?.submitButton.setTitle("Submit", for: .normal)
			self?.isSubmitButtonActive(false)
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
		getValuesForLabels()
	}
	
	func getValuesForLabels(){
		var calculationResults : (longSide:String,shortSide:String) = ("","")
		do {
			guard let result = try values?.getCalculation() else {return}
			calculationResults.longSide = result.longGrain
			calculationResults.shortSide = result.shortGrain
		} catch (let error) {
			print(error.localizedDescription)
			makeViewOriginalView()
		}
		assignValuesToLabelsOnResultsView(long: calculationResults.longSide, short: calculationResults.shortSide)
	}
	
	func assignValuesToLabelsOnResultsView(long:String, short:String){
		longSideResultLabel.text = long
		shortSideResultLabel.text = short
	}
	
	func isSubmitButtonActive(_ bool:Bool){
		switch bool {
			case true:
				submitButton.alpha = 1.0
			default:
				submitButton.alpha = 0.3
		}
		submitButton.isEnabled = bool
	}
	
	//MARK: IBACTIONS
	
	@IBAction func valueChanged(_ sender: Any) {
		tableView.contentOffset = CGPoint(x: 0, y: 215)
		if shortSideParentSheet.text != "" && shortEndPieceSize.text != "" && longSideParentSheet.text != "" && longEndPieceSize.text != "" {
			isSubmitButtonActive(true)
		}else{
			isSubmitButtonActive(false)
		}
	}
	
	
	@IBAction func tappedSubmitButton(_ sender: Any) {
		// Evaluates what is on the screen.
		switch resultsAreVisable {
			case true:
				makeViewOriginalView()
				isSubmitButtonActive(false)
			default:
				makeResultsVisable()
		}
	}
}

extension PaperCalculatorViewController : UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
	}
	
}
