//
//  StringExtension.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/10/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

extension String {
	 func capitalizeFirstLetter()->String{
		let components = self
		let withOutFirstLetter = components.dropFirst()
		let items : [Character] = components.map {$0}
		let firstLetter = items[0].uppercased()
		
		return "\(firstLetter)\(withOutFirstLetter)"
		}
}
