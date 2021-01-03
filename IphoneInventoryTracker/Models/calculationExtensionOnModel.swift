//
//  calculationExtensionOnModel.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/17/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

extension Stock {
	// We throw the error up the hierarchy
	mutating func performCalculations<T: Hashable>(amountOfPiecesNeededForOrder: T, shortEdge: T, longEdge: T) throws {
		// Converted incoming amout back into an integer from a double.
		guard let newValue = amountOfPiecesNeededForOrder as? Double, let amount = self.amount else { return }
		guard let short = shortEdge as? Double, let long = longEdge as? Double else { return }
		
		let size = self.parentSheetSize
		var parentSheetShortEnd: Double = Double()
		var parentSheetLongEnd: Double = Double()
		var newtotal: Int = Int()
		
		// Predetermined sizes this is where any additional sizes would be added.
		switch size {
			case .letter:
				parentSheetShortEnd = 8.5
				parentSheetLongEnd = 11
			try verifyAmounts(parentSheetShortEnd, parentSheetLongEnd, newValue, short, long, amount)
			case .legal:
				parentSheetShortEnd = 8.5
				parentSheetLongEnd = 14
			try verifyAmounts(parentSheetShortEnd, parentSheetLongEnd, newValue, short, long, amount)
			case .tabloid:
				parentSheetShortEnd = 11
				parentSheetLongEnd = 17
			try verifyAmounts(parentSheetShortEnd, parentSheetLongEnd, newValue, short, long, amount)
			case .oversized:
				parentSheetShortEnd = 12
				parentSheetLongEnd = 18
			try verifyAmounts(parentSheetShortEnd, parentSheetLongEnd, newValue, short, long, amount)
			case ._9Envelope:
				parentSheetShortEnd = 3.75
				parentSheetLongEnd = 8.625
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			case ._10Envelope:
				parentSheetShortEnd = 4.125
				parentSheetLongEnd = 9.5
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			default:
				break
		}
	}
}

extension Stock {
	
	// Changes value of Amount Property.
	mutating func verifyAmounts(_ parentSheetShortEnd: Double, _ parentSheetLongEnd: Double, _ newValue: Double, _ short: Double, _ long: Double, _ amount: Int) throws {
		var newtotal: Int = 0
		
		try newtotal = sheetsOut(short, long, parentSheetShortEnd, parentSheetLongEnd)
		
		// We have to make sure we exhaust the amount available from one sheet before moving on the sheet 2
		let checkValueForLessThanZeroButNotZero = newValue / Double(newtotal)
		if checkValueForLessThanZeroButNotZero > 0 && checkValueForLessThanZeroButNotZero < 1 && checkValueForLessThanZeroButNotZero < Double(newtotal) {
			newtotal = 1
			let value = 1 // * (Int(newValue) / newtotal + 1)
			self.amount = amount - (value / newtotal)
		}else{
			self.amount = amount - (Int(newValue) / newtotal)
		}
		
	}
	
	private func sheetsOut(_ short: Double, _ long: Double, _ parentShort: Double, _ parentLong: Double) throws -> Int {
		let longGrainValue: Double
		let shortGrainValue: Double
		
		// Values all need to be converted into doubles in order to get the correct % returned once the value is converted back into an integer.
		longGrainValue = removeDecimalsAfterOperation(size: parentShort/short) * removeDecimalsAfterOperation(size: parentLong/long)
		shortGrainValue = removeDecimalsAfterOperation(size: parentShort/long) * removeDecimalsAfterOperation(size: parentLong/short)
		
		//Throws an error if the size of the sheet is larger than the parent size
		if longGrainValue == 0 && shortGrainValue == 0 {
			throw DivisionError.noValueResultingInDivisionByZeroError
		}
		
		// For calculating the amount of sheets will be used this actually doesnt matter. However if this code is being used to create an amount-out calculator this information matters.
		if longGrainValue > shortGrainValue {
			return Int(longGrainValue)
		}else{
			return Int(shortGrainValue)
		}
	}
	
	/// Takes an incoming double removes everything after the decimal point. The result is NOT equivalent to --> . `String(format: "%.0f")`
	/// - Parameter value: Double that will be rounded down.
	/// - Returns: A double that will be used count needed sheets.
	/// - Important: We always disgard the remainder because this is calculating a physical count where any remainder would constitute an imaginary quantity.
	private func removeDecimalsAfterOperation(size value: Double) -> Double {
		let valueAsString = String(value)
		let valueWithoutDecimal = valueAsString.split(separator: ".")
		let stringForIntegerValue = valueWithoutDecimal[0]
		guard let doubleValue = Double(stringForIntegerValue) else { fatalError() }
		return doubleValue
	}
	// Changes value of PercentRemaining Property.
	mutating func setPercentageAmount() {
		guard let amount = self.amount, let recommendedAmount = self.recommendedAmount else { return }
		self.percentRemaining = Int(Double(amount) / Double(recommendedAmount) * 100)
	}
}



// Creating Error Case For Division by Zero
enum DivisionError : Error {
	case noValueResultingInDivisionByZeroError
}



