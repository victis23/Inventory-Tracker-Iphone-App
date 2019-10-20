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
	mutating func performCalculations<T: Hashable>( incomingAmount : T, shortEdge : T, longEdge : T) throws {
		// converted incoming amout back into an integer from a double
		guard let newValue = incomingAmount as? Double, let amount = self.amount else {return}
		
		guard let short = shortEdge as? Double, let long = longEdge as? Double else {return}
		
		let size = self.parentSheetSize
		var parentSheetShortEnd : Double = Double()
		var parentSheetLongEnd : Double = Double()
		var newtotal : Int = Int()
		
		switch size {
			case .letter:
				parentSheetShortEnd = 8.5
				parentSheetLongEnd = 11
			case .legal:
				parentSheetShortEnd = 8.5
				parentSheetLongEnd = 14
			case .tabloid:
				parentSheetShortEnd = 11
				parentSheetLongEnd = 17
			case .oversized:
				parentSheetShortEnd = 12
				parentSheetLongEnd = 18
			case ._9Envelope:
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			case ._10Envelope:
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			default:
			break
		}
		try verifyAmounts(parentSheetShortEnd, parentSheetLongEnd, newValue, short, long, amount)
	}
	
	private func sheetsOut(_ short : Double, _ long : Double, _ parentShort : Double, _ parentLong :Double) throws -> Int {
			let longGrainValue : Double
			let shortGrainValue : Double
			
			longGrainValue = removeDecimalsAfterOperation(size: parentShort/short) * removeDecimalsAfterOperation(size: parentLong/long)
				
			shortGrainValue = removeDecimalsAfterOperation(size: parentShort/long) * removeDecimalsAfterOperation(size: parentLong/short)
		
		//Makes sure to throw an error if the size of the sheets is larger than the existing size!
		if longGrainValue == 0 && shortGrainValue == 0 {
			throw DivisionError.noValueResultingInDivisionByZeroError
		}
			
			if longGrainValue > shortGrainValue {
				return Int(longGrainValue)
			}else{
				return Int(shortGrainValue)
			}
		}
		
		private func removeDecimalsAfterOperation(size value:Double)->Double {
			let valueAsString = String(value)
			let valueWithoutDecimal = valueAsString.split(separator: ".")
			let stringForIntegerValue = valueWithoutDecimal[0]
			guard let doubleValue = Double(stringForIntegerValue) else {fatalError()}
			return doubleValue
		}
	
	mutating func setPercentageAmount(){
		guard let amount = self.amount, let recommendedAmount = self.recommendedAmount else {return}
		self.percentRemaining = Int(Double(amount) / Double(recommendedAmount) * 100)
	}
}



extension Stock {


	mutating func verifyAmounts(_ parentSheetShortEnd : Double, _ parentSheetLongEnd :Double, _ newValue :Double, _ short :Double, _ long : Double, _ amount : Int) throws {
		var newtotal : Int = 0
		
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
	
}

// Creating Error Case For Division by Zero
enum DivisionError : Error {
	case noValueResultingInDivisionByZeroError
}
	
	

