//
//  InventoryTracker_CollectionViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit


class InventoryTracker_CollectionViewController: UIViewController, UICollectionViewDelegate {
	
	@IBOutlet weak var searchField: UISearchBar!
	
	private struct CellIdentifiers {
		static var collectionViewKey = "cell"
	}
	
	fileprivate struct SegueIdentifiers {
		static var cancel = "cancel"
		static var addStock = "newStock"
		static var newOrder = "newOrder"
		static var moreStock = "moreStock"
	}
	
	//MARK: IBOutlets
	@IBOutlet weak var inventoryDetailCollection :UICollectionView!
	var dataSource :DataSource!
	
	var stock : [Stock]? = [] {
		didSet {
			let sortedStock = stock?.sorted(by: { (first, second) -> Bool in
				first.percentRemaining! < second.percentRemaining!
			})
			stock = sortedStock
			guard let updatedStock = stock else {fatalError("Unable to perform unwrap!")}
			createSnapShot(updatedStock)
			Stock.encode(updatedStock)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let layOut = createLayout()
		inventoryDetailCollection.collectionViewLayout = layOut
		setupDataSource()
		intialSetupOfExistingData()
		inventoryDetailCollection.delegate = self
	}
	
	func intialSetupOfExistingData(){
		self.navigationController?.navigationBar.prefersLargeTitles = true
		let model = Stock.decode() as [Stock]?
		guard let unWrappedmodel = model else {return}
		let decodedModel : [Stock] = unWrappedmodel
		stock = decodedModel
	}
	
	//MARK: - CollectionView Delegate Methods
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let model = dataSource.itemIdentifier(for: indexPath)
		
		let alertController = UIAlertController(title: "Modify Existing Stock", message: "Please select how you'd like to update the stock amount.", preferredStyle: .alert)
		let newOrder = UIAlertAction(title: "New Order", style: .default) { (action) in
			self.performSegue(withIdentifier: SegueIdentifiers.newOrder, sender: model)
		}
		let addStock = UIAlertAction(title: "Update Stock Amount", style: .default) { (action) in
			self.performSegue(withIdentifier: SegueIdentifiers.moreStock, sender: model)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		let delete = UIAlertAction(title: "Delete", style: .destructive) { (item) in
			self.stock?.remove(at: indexPath.item)
			
		}
		alertController.addAction(newOrder)
		alertController.addAction(addStock)
		alertController.addAction(delete)
		alertController.addAction(cancel)
		present(alertController, animated: true, completion: nil)
	}
	
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.newOrder{
			let destinationController = segue.destination as! UINavigationController
			let controller = destinationController.topViewController as! NewOrder_TableViewController
			guard let  model = sender as? Stock else {return}
			controller.setModelForController(model)
		}
		if segue.identifier == SegueIdentifiers.moreStock{
			let destinationController = segue.destination as! UINavigationController
			let controller = destinationController.topViewController as! MoreStock_TableViewController
			guard let model = sender as? Stock else {return}
			controller.setModelForController(model)
		}
	}
	
	@IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {}
}



extension InventoryTracker_CollectionViewController {
	
	//MARK: UICollectionViewDataSourceMethods
	
	func setupDataSource(){
		dataSource = DataSource(collectionView: inventoryDetailCollection, cellProvider: { (collectionView, indexPath, items) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.collectionViewKey, for: indexPath) as! InventoryDetailCell_CollectionViewCell
			
			// I decieded to convert the values of amount & recommended amount here instead of doing it in the model because of the simplicity of converting straight to Int without having to round up
			guard let amount = items.amount else {fatalError()}
			guard let recommendedAmount = items.recommendedAmount else {fatalError()}
			let remainingPercentage = Double(amount)/Double(recommendedAmount) * 100
			
			cell.amountLabel.text = String(items.amount!)
			cell.nameLabel.text = items.name
			cell.stockWeightLabel.text = "Weight: \(items.weight!.rawValue)"
			cell.stockSizeLabel.text = "Size: \(items.parentSheetSize!.rawValue)"
			cell.stockColorLabel.text = "Color: \(items.color!)"
			cell.percentageRemainingLabel.text = "\(Int(remainingPercentage))%"
			
			cell.contentView.layer.cornerRadius = 10
			cell.contentView.layer.shadowOpacity = 1.0
			cell.backGroundViewForCell.layer.shadowOpacity = 1
			cell.backGroundViewForCell.layer.shadowRadius = 5
			cell.contentView.layer.shadowRadius = 5
			cell.contentView.clipsToBounds = true
			cell.cartonStatus.alpha = 0.25
			guard remainingPercentage <= 50 else {
				cell.cartonStatus.image = UIImage(named: "Full")
				return cell}
			cell.cartonStatus.image = UIImage(named: "Empty")
			return cell
		})
	}
	
	
	// MARK: UICollectionViewDelegate
	
	func createLayout()->UICollectionViewCompositionalLayout{
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
		
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
		
		let section = NSCollectionLayoutSection(group: group)
		let layout = UICollectionViewCompositionalLayout(section: section)
		
		return layout
	}
	
	func createSnapShot(_ model :[Stock]?){
		var snapShot = NSDiffableDataSourceSnapshot<Sections,Stock>()
		guard let currentStock = model else {return}
		snapShot.appendSections([.main])
		snapShot.appendItems(currentStock, toSection: .main)
		dataSource.apply(snapShot, animatingDifferences: true) {
			self.inventoryDetailCollection.reloadData()
		}
	}
}

