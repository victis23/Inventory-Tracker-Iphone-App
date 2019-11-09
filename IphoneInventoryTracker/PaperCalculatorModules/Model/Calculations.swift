//
//  Calculations.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/9/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

struct Calculations {
	var shortEndOnParentSize:Double
	var longEndOnParentSize:Double
	var shortEndOnPiece:Double
	var longEndOnPiece:Double
	
	init(sParent: Double, lParent:Double, sPiece:Double, lPiece:Double) {
		self.shortEndOnParentSize = sParent
		self.longEndOnParentSize = lParent
		self.shortEndOnPiece = sPiece
		self.longEndOnPiece = lPiece
	}
	
	func getCalculation() throws ->(longGrain: String, shortGrain: String){
		
		let longGrainValue: Double
		let shortGrainValue :Double
		
		longGrainValue = convertValuesIntoIntergersWithNoRemainder(with: shortEndOnParentSize/shortEndOnPiece) * convertValuesIntoIntergersWithNoRemainder(with: longEndOnParentSize/longEndOnPiece)
		
		shortGrainValue = convertValuesIntoIntergersWithNoRemainder(with: shortEndOnParentSize/longEndOnPiece) * convertValuesIntoIntergersWithNoRemainder(with: longEndOnParentSize/shortEndOnPiece)
		
		if longGrainValue == 0 && shortGrainValue == 0 {
			throw DivisionError.noValueResultingInDivisionByZeroError
		}
		let longGrain = String(format: "%.0f", longGrainValue)
		let shortGrain = String(format: "%.0f", shortGrainValue)
		
		return (longGrain, shortGrain)
		
	}
	
	func convertValuesIntoIntergersWithNoRemainder(with
		value:Double)->Double{
		/*
		let stringValue = String(format: "%.0f", value)
		guard let newValue = Double(stringValue) else {fatalError()}
		return newValue
		*/
		let valueAsString = String(value)
		let valueWithoutDecimal = valueAsString.split(separator: ".")
		let stringForIntegerValue = valueWithoutDecimal[0]
		guard let doubleValue = Double(stringForIntegerValue) else {fatalError()}
		return doubleValue
	}
}


