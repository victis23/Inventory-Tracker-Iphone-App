//
//  InventoryTracker_CollectionViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit


class InventoryTracker_CollectionViewController: UICollectionViewController {
	
	private struct CellIdentifiers {
		static var collectionViewKey = "cell"
	}
	
	fileprivate struct SegueIdentifiers {
		static var cancel = "cancel"
	}
	
	
	//MARK: IBOutlets
	@IBOutlet weak var inventoryDetailCollection :UICollectionView!
	
	var dataSource :DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
		setupDataSource()
    }
	

  
    // MARK: - Navigation

	@IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
		
		let identifier = unwindSegue.identifier
		
		switch identifier {
			case SegueIdentifiers.cancel:
			print("View was dismissed without action.")
			default:
			break
		}
		
	}
	

}
   


extension InventoryTracker_CollectionViewController {
	
	//MARK: UICollectionViewDataSourceMethods
	
	func setupDataSource(){
		dataSource = DataSource(collectionView: inventoryDetailCollection, cellProvider: { (collectionView, indexPath, items) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.collectionViewKey, for: indexPath) as! InventoryDetailCell_CollectionViewCell
			
			return cell
		})
	}


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

