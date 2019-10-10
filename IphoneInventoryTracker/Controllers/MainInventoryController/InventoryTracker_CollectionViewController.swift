//
//  InventoryTracker_CollectionViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit


class InventoryTracker_CollectionViewController: UIViewController {
	
	private struct CellIdentifiers {
		static var collectionViewKey = "cell"
	}
	
	fileprivate struct SegueIdentifiers {
		static var cancel = "cancel"
		static var addStock = "newStock"
	}

	
	
	//MARK: IBOutlets
	@IBOutlet weak var inventoryDetailCollection :UICollectionView!
	var dataSource :DataSource!
	var stock : [Stock]? = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let layOut = createLayout()
		inventoryDetailCollection.collectionViewLayout = layOut
		setupDataSource()
		//createSnapShot(stock)
    }
	
	//MARK: IBAction
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
			
			cell.selectedBackgroundView?.layer.backgroundColor = UIColor.systemBlue.cgColor
			print("Incoming Value was — \(self.stock!)")
			return cell
		})
	}


    // MARK: UICollectionViewDelegate

	func createLayout()->UICollectionViewCompositionalLayout{
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		
		let item = NSCollectionLayoutItem(layoutSize: groupSize)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		let section = NSCollectionLayoutSection(group: group)
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
	
	func createSnapShot(_ model :[Stock]?){
		var snapShot = NSDiffableDataSourceSnapshot<Sections,Stock>()
		guard let currentStock = model else {return}
		
		
			snapShot.appendSections([.main])
			snapShot.appendItems(currentStock, toSection: .main)
			dataSource.apply(snapShot)
	}
}

