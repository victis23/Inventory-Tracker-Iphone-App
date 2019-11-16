//
//  Tests.swift
//  Tests
//
//  Created by Scott Leonard on 11/16/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import XCTest
@testable import Inventory_Tracker

class Tests: XCTestCase {
	let vc = InventoryTracker_CollectionViewController()
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testListIsEmpty(){
		
		XCTAssertNotNil(vc.costDelegate)
		
	}
	
	
}
