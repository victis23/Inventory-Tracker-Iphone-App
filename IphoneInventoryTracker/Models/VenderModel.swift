//
//  VenderModel.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import Foundation

struct VenderInfo {
	var name: Vender
	var address :String
	var phone :String
	var email :String
	var website :URL?
}

enum Vender :String , CaseIterable{
	case Case = "Case Papers"
	case Veritiv
	case MacPapers = "Mac Papers"
}
