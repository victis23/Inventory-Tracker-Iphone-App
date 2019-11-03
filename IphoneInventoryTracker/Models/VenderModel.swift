//
//  VenderModel.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

struct Vender: Hashable, Codable, Equatable {
	var name: String
	var address :String
	var phone :String
	var email :String
	var website :URL?
	let identifier = UUID()
	
	func hash(into hasher : inout Hasher){
		hasher.combine(identifier)
	}
	static func ==(lhs:Vender, rhs:Vender) -> Bool {
		lhs.identifier == rhs.identifier
	}
}

