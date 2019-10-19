//
//  calculationExtensionOnModel.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/17/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

extension Stock {
	mutating func performCalculations<T: Hashable>( incomingAmount : T, shortEdge : T, longEdge : T){
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
				newtotal = sheetsOut(short, long, parentSheetShortEnd, parentSheetLongEnd)
				self.amount = amount - (Int(newValue) / newtotal)
			case .legal:
				parentSheetShortEnd = 8.5
				parentSheetLongEnd = 14
				newtotal = sheetsOut(short, long, parentSheetShortEnd, parentSheetLongEnd)
				self.amount = amount - (Int(newValue) / newtotal)
			case .tabloid:
				parentSheetShortEnd = 11
				parentSheetLongEnd = 17
				newtotal = sheetsOut(short, long, parentSheetShortEnd, parentSheetLongEnd)
				self.amount = amount - (Int(newValue) / newtotal)
			case .oversized:
				parentSheetShortEnd = 12
				parentSheetLongEnd = 18
				newtotal = sheetsOut(short, long, parentSheetShortEnd, parentSheetLongEnd)
				self.amount = amount - (Int(newValue) / newtotal)
			case ._9Envelope:
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			case ._10Envelope:
				newtotal = amount - Int(newValue)
				self.amount = newtotal
			default:
			break
		}
	}
	
	private func sheetsOut(_ short : Double, _ long : Double, _ parentShort : Double, _ parentLong :Double) -> Int {
			let longGrainValue : Double
			let shortGrainValue : Double
			
			longGrainValue = removeDecimalsAfterOperation(size: parentShort/short) * removeDecimalsAfterOperation(size: parentLong/long)
				
			shortGrainValue = removeDecimalsAfterOperation(size: parentShort/long) * removeDecimalsAfterOperation(size: parentLong/short)
			
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
	
	

