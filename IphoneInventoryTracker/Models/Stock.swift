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
	var parentSheetSize :ParentSize
	var weight :Weight
	var amount :Int
	var recommendedAmount :Int
	var vender : Vender
	var identifier = UUID()

	static func ==(lhs :Stock, rhs :Stock) -> Bool{
		return lhs.identifier == rhs.identifier
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
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

}

enum ParentSize{
	
}

enum Vender :String{
	case Case
	case Veritiv
	case MacPapers = "Mac Papers"
}
