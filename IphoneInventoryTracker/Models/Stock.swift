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
	let identifier = UUID()
	
	static func ==(lhs :Stock, rhs :Stock) -> Bool{
		return lhs.identifier == rhs.identifier
	}
}

struct CurrentInventory {
	var currentStocks : [Stock : Int]
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
