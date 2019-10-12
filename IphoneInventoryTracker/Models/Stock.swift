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

struct Stock : Hashable, Equatable {
	var name :String?
	var parentSheetSize :ParentSize?
	var weight :Weight?
	var amount :Int?
	var recommendedAmount :Int?
	var vender : Vender?
	var identifier = UUID()
	var color : String?
	var cost : String?
	var percentRemaining : Double?

	static func ==(lhs :Stock, rhs :Stock) -> Bool{
		return lhs.identifier == rhs.identifier
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}
	
	init(_ name :String) {
		self.name = name
	}
	
	init(_ name :String?, _ parentSheetSize:ParentSize?, _ weight:Weight?, _ amount:Int?, _ recommendedAmount:Int?, _ vender:Vender?) {
		self.name = name
		self.parentSheetSize = parentSheetSize
		self.weight = weight
		self.amount = amount
		self.recommendedAmount = recommendedAmount
		self.vender = vender
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

enum Weight:String, CaseIterable, Codable{
	case _20Bond = "#20 Bond"
	case _60Bond = "#60 Bond"
	/* Text */
	case _70Accent = "#70 Uncoated Text"
	case _80Accent = "#80 Uncoated Text"
	case _80GlossText = "#80 Gloss Text"
	case _100GlossText = "#100 Gloss Text"
	/* Cover */
	case _65Cover = "#65 Uncoated Cover"
	case _80Cover = "#80 Uncoated Cover"
	case _100Cover = "#100 Uncoated Cover"
	case _80GlossCover = "#80 Gloss Cover"
	case _100GlossCover = "#100 Gloss Cover"
	case _12PtC2S = "12pt C2S"
}

enum ParentSize :String, CaseIterable, Codable{
	case letter = "8.5 x 11"
	case legal = "8.5 x 14"
	case tabloid = "11 x 17"
	case oversized = "12 x 18"
	case _9Envelope = "#9 Envelope"
	case _10Envelope = "#10 Envelope"
}


extension Stock : Codable {
	
	static func filePath()->URL{
		let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let file = path.appendingPathComponent("savedModel").appendingPathExtension("json")
		return file
	}
	
	static func encode<T:Codable>(_ model : [T]){
		let encoder = JSONEncoder()
		guard let encodedData = try? encoder.encode(model) else {fatalError("Was unable to encode incoming data!")}
		try? encodedData.write(to: filePath())
	}
	
	static func decode<T :Decodable>()->[T]?{
		let decoder = JSONDecoder()
		guard let rawData = try? Data(contentsOf: filePath()) else {return nil}
		guard let decodedDataModel = try? decoder.decode([T].self, from: rawData) else {return nil}
		return decodedDataModel
	}
}


