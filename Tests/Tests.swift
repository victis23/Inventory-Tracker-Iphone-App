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
	
	var vc : InventoryTracker_CollectionViewController!
	var _10Envelopes : Stock!
	var _postCardCounts : Stock!
	
	override func setUp() {
		vc = InventoryTracker_CollectionViewController()
		vc.costDelegate = nil
		_postCardCounts = Stock()
	}
	
	override func tearDown() {
		
	}
	
	func testCostDelegateNotNil(){
		vc.costDelegate = CostOfSpentGoodsTableViewController()
		XCTAssertNotNil(vc.costDelegate)
	}
	
	func testCostDelegateIsNil(){
		XCTAssertNil(vc.costDelegate)
	}
	
	// Tests whether calculations are being done correctly for envelopes.
	func testPerformCalculationsForEnvelopes() throws {
		_10Envelopes = Stock("Test", ._10Envelope, ._20Bond, 1000, 100, nil)
		
		 try _10Envelopes.performCalculations(amountOfPiecesNeededForOrder: 500, shortEdge: 4.125, longEdge: 9.5)
		
		XCTAssertTrue(_10Envelopes.amount == 500)
	}
	
	// Tests whether calculations are being done correctly for normal stock.
	func testNormalCalculations() throws {
		_postCardCounts.amount = 100
		_postCardCounts.parentSheetSize = .oversized
		_postCardCounts.name = "Heavy Post Cards"
		_postCardCounts.weight = ._12PtC2S
		
		try _postCardCounts.performCalculations(amountOfPiecesNeededForOrder: 100, shortEdge: 4.25, longEdge: 6.25)
		
		XCTAssertTrue(_postCardCounts.amount == 75)
	}
	
}
