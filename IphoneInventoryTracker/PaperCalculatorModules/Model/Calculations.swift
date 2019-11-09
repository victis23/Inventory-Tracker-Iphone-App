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
	
	func performCalculation(){
		
	}
}
