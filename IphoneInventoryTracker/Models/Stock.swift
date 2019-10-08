//
//  Stock.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

struct Order {
	var stock :Stock
	var orderAmount :Int
	var pieceSize :Float
}

struct Stock : Hashable {
	var name :String
	var parentSheetSize :ParentSize?
	var weight :Weight?
	var amount :Int?
	var recommendedAmount :Int?
	var vender : Vender?
	var identifier = UUID()

	static func ==(lhs :Stock, rhs :Stock) -> Bool{
		return lhs.identifier == rhs.identifier
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}
	
	init(_ name :String) {
		self.name = name
	}
}

struct CurrentInventory {
	var currentStocks : [Stock : Int]
	var currentPapers : [Stock] {
		return currentStocks.map {$0.key}
	}
	
	init(_ currentStocks :[Stock : Int]) {
		self.currentStocks = currentStocks
	}
}

enum Weight{
	case test
}

enum ParentSize :String, CaseIterable{
	case letter = "8.5 x 11"
	case legal = "8.5 x 14"
	case tabloid = "11 x 17"
	case oversized = "12 x 18"
	case generic1 = "generic1"
	case generic2 = "generic2"
}

enum Vender :String{
	case Case
	case Veritiv
	case MacPapers = "Mac Papers"
}
