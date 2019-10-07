//
//  DataSource_InventoryTracker.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

extension InventoryTracker_CollectionViewController {

	class DataSource : UICollectionViewDiffableDataSource<Sections,Stock> {
		
		override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return 1
		}
	}
}
