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
	@IBOutlet weak var submitButtonYConstraint: NSLayoutConstraint!
	@IBOutlet weak var staticCell: UITableViewCell!
	@IBOutlet weak var titleYconstraint: NSLayoutConstraint!
	
	@IBOutlet weak var titleLabel: UILabel!
	
	//MARK: Properties
	// Switch used to evaluate which view is currently being precented to user.
	// ***** Value starts at as true because it is changed upon view did load to false!
	var resultsAreVisable = true
	// Holds the result of the finished cuts calculation.
	var values : Calculations?
	// Collection of textFields used to make changes to entire group faster.
	var textFields : [UITextField?] = []
	
	//MARK: State
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAesthetic()
		setUpTextFields()
		isSubmitButtonActive(false)
	}
	
	//MARK: Methods
	/// Sets aesthetics that will be visable within the view controller.
	/// Sets submit button to `DISABLED`
	/// - Note: This is the default view.
	func setupAesthetic(){
		tableView.keyboardDismissMode = .interactive
		submitButton.layer.cornerRadius = 10
		resultsView.layer.cornerRadius = 10
		makeViewOriginalView()
	}
	
	/// Assigns `textfield` views to collection for easy manipulation.
	///  - Important:
	///  	- Assigns each text field to the textField property.
	/// These need to be placed in the array in this particular order because `initalizeObject()` will be using them to create our model.
	/// 1. `shortSideParentSheet`
	/// 2. `longSideParentSheet`
	/// 3. `shortEndPieceSize`
	/// 4. `longEndPieceSize`
	func setUpTextFields(){
		self.textFields = [self.shortSideParentSheet,self.longSideParentSheet, self.shortEndPieceSize, self.longEndPieceSize]
	}
	
	/// Returns view to original view with results view moved off screen.
	func makeViewOriginalView(){
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.staticCell.frame.size.height = 500
			self?.titleYconstraint.constant = -230
			self?.titleLabel.transform = .identity
			self?.mainStack.transform = .identity
			self?.resultsView.transform = CGAffineTransform(translationX: -450, y: 0)
			self?.submitButton.setTitle("Submit", for: .normal)
			self?.submitButtonYConstraint.constant = 225
			self?.view.layoutIfNeeded()
		}
		isSubmitButtonActive(false)
		shortSideParentSheet.becomeFirstResponder()
		resultsAreVisable = !resultsAreVisable
	}
	
	/// Presents pop-over view that contains labels that show the results.
	func makeResultsVisable(){
		view.endEditing(true)
		UIView.animate(withDuration: 1.5) { [weak self] in
			self?.staticCell.frame.size.height = 900
			self?.titleYconstraint.constant = -400
			self?.titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
			self?.mainStack.transform = CGAffineTransform(translationX: 450, y: 0)
			self?.resultsView.transform = CGAffineTransform(translationX: 0, y: -65)
			self?.submitButton.setTitle("Return", for: .normal)
			self?.view.layoutIfNeeded()
		}
		initalizeObject()
		//Clears values placed in field by user on each item during transfer.
		textFields.forEach({$0?.text = ""})
		// Changes boolean value of controller switch.
		resultsAreVisable = !resultsAreVisable
	}
	
	/// Unwraps & converts the text value of each UITextField `String --> Double` & appends to ordered collection of `userInputValues`.
	/// - Note: This method is called from `makeResultsVisable` which in turn can only be called once all text fields are filled. This is done as a precautions because otherwise this method fails with an `index out of range` error.
	func initalizeObject(){
		var userInputValues : [Double] = []
		textFields.forEach({
			guard let unamedValue = $0?.text, let numbericValue = Double(unamedValue) else {return}
			userInputValues.append(numbericValue)
		})
		values = Calculations(sParent: userInputValues[0], lParent: userInputValues[1], sPiece: userInputValues[2], lPiece: userInputValues[3])
		getValuesForLabels()
	}
	
	/// Calls object method that performs that calculations.
	/// - Throws: This method catches an error from object if both calculations return 0. This would indicate that the user is trying to get a larger output than possible from the provided input.
	/// - Important: This calculation deals with a physical item that can not be fractional. Any remainders are disgarded and the value is dropped down to the next integer value.
	/// - Note: The object method returns a tuple of string type values `(longGrain:, shortGrain:)`
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
	
	/// Assigns tuple value retrieved in `getValueForLabels()`
	/// - Parameters:
	///   - long: Value for pieces out along the longer axis of the sheet.
	///   - short: Value for pieces out along the shorter axis of the sheet.
	func assignValuesToLabelsOnResultsView(long:String, short:String){
		longSideResultLabel.text = long
		shortSideResultLabel.text = short
	}
	
	/// Controls the aesthetic of view for button depending on whether it is active.
	/// - Parameter bool: State of button.
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
	
	/// Verifies whether all fields hold values. If true — enables submit button.
	/// - Parameter sender: Sender is a `UITextField` but it's values are not used in this method.
	@IBAction func valueChanged(_ sender: Any) {
		// Method breaks solid — Adjusts position of tableView cell as well as checks status of fields. Two birds with one stone?
		//		tableView.contentOffset = CGPoint(x: 0, y: 215)
		if shortSideParentSheet.text != "" && shortEndPieceSize.text != "" && longSideParentSheet.text != "" && longEndPieceSize.text != "" {
			isSubmitButtonActive(true)
		}else{
			isSubmitButtonActive(false)
		}
	}
	
	
	/// Controls what view is presented to controller when user taps the submit button.
	/// - Parameter sender: Sender is `UIButton` | value is not used.
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
