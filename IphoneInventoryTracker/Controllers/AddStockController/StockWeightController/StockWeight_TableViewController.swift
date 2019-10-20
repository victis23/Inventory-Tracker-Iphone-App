//
//  StockType_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class StockWeight_TableViewController: UITableViewController {
	
	private enum Section {
		case bond
		case cover
		case text
	}
	
	private struct SegueIdentifiers {
		static var returnToNewStock = "weightToHome"
	}
	
	fileprivate struct StockTypes : Hashable{
		var defaultTextForBond :String?
		var defaultTextForText :String?
		var defaultTextForCover :String?
		var bond :Stock?
		var text :Stock?
		var cover :Stock?
		let identifier = UUID()
		
		func hash(into hasher: inout Hasher){
			hasher.combine(identifier)
		}
		
		init(textForBond :String) {
			self.defaultTextForBond = textForBond
		}
		init(textForText :String) {
			self.defaultTextForText = textForText
		}
		init(textForCover :String) {
			self.defaultTextForCover = textForCover
		}
		init(bond:Stock) {
			self.bond = bond
		}
		init(text:Stock) {
			self.text = text
		}
		init(cover:Stock) {
			self.cover = cover
		}
	}
	
	fileprivate var selectOption : [StockTypes] = [StockTypes(textForBond: "Select Option")]
	fileprivate var selectOption2 : [StockTypes] = [StockTypes(textForText: "Select Option")]
	fileprivate var selectOption3 : [StockTypes] = [StockTypes(textForCover: "Select Option")]
	
	fileprivate var defaultBond : [StockTypes] = [
		StockTypes(bond: Stock(nil, nil, ._20Bond, nil, nil, nil)),
		StockTypes(bond: Stock(nil, nil, ._60Bond, nil, nil, nil))
	]
	
	fileprivate var defaultText : [StockTypes] = [
		StockTypes(text: Stock(nil, nil, ._70Accent, nil, nil, nil)),
		StockTypes(text: Stock(nil, nil, ._80Accent, nil, nil, nil)),
		StockTypes(text: Stock(nil, nil, ._80GlossText, nil, nil, nil)),
		StockTypes(text: Stock(nil, nil, ._100GlossText, nil, nil, nil)),
	]
	
	fileprivate var defaultCover : [StockTypes] = [
		StockTypes(cover: Stock(nil, nil, ._65Cover, nil, nil, nil)),
		StockTypes(cover: Stock(nil, nil, ._80Cover, nil, nil, nil)),
		StockTypes(cover: Stock(nil, nil, ._100Cover, nil, nil, nil)),
		StockTypes(cover: Stock(nil, nil, ._80GlossCover, nil, nil, nil)),
		StockTypes(cover: Stock(nil, nil, ._100GlossCover, nil, nil, nil)),
		StockTypes(cover: Stock(nil, nil, ._12PtC2S, nil, nil, nil))
	]
	
	private var dataSource : Datasource!
	var userSelectedItem :String!
	var userSelectedModel : Weight!
	var selectedIndex : IndexPath!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setDataSource()
		setSnapShot(selectOption, selectOption2, selectOption3, animated: true)
    }
	
	private class Datasource : UITableViewDiffableDataSource<Section,StockTypes>{
		
		override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
			switch section {
				case 0:
				return "Bond Weight Stock"
				case 1:
				return "Text Weight Stock"
				case 2:
				return "Cover Weight Stock"
				default:
				return nil
			}
		}
	}
}

extension StockWeight_TableViewController {
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let identifier = dataSource.itemIdentifier(for: indexPath)
		let row = indexPath.row // being called within the unWrappedIdentifer Switch Statement
		guard let unWrappedIdentifier = identifier?.identifier else {return}
		
		if identifier?.bond?.weight != nil {
			tableView.reloadData()
			userSelectedModel = identifier?.bond?.weight
			returnToNewStock()
		}else if identifier?.text?.weight != nil {
			tableView.reloadData()
			userSelectedModel = identifier?.text?.weight
			returnToNewStock()
		}else if identifier?.cover?.weight != nil {
			tableView.reloadData()
			userSelectedModel = identifier?.cover?.weight
			returnToNewStock()
		}else{
			switch unWrappedIdentifier {
				case selectOption[row].identifier:
					setSnapShot(defaultBond, selectOption2, selectOption3, animated: true)
				case selectOption2[row].identifier:
					setSnapShot(selectOption, defaultText, selectOption3, animated: true)
				case selectOption3[row].identifier:
					setSnapShot(selectOption, selectOption2, defaultCover, animated: true)
				default:
				break
			}
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	fileprivate func setSnapShot(_ bond:[StockTypes],_ text:[StockTypes], _ cover:[StockTypes], animated:Bool){
		
		var snapShot :NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,StockTypes>()
		
		snapShot.appendSections([.bond,.text,.cover])
		snapShot.appendItems(bond, toSection: .bond)
		snapShot.appendItems(text, toSection: .text)
		snapShot.appendItems(cover, toSection: .cover)
		
		UIView.animate(withDuration: 0.5) {
			self.dataSource.apply(snapShot, animatingDifferences: animated, completion: nil)
		}
		
	}
	
	func setDataSource(){
		dataSource = Datasource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
			
			let section = indexPath.section
			let row = indexPath.row
			let currentModel = self.dataSource.itemIdentifier(for: indexPath)
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.weight, for: indexPath) as! StockWeight_TableViewCell
			let userModel = self.userSelectedModel
			
			switch section {
				case 0:
					guard currentModel?.identifier == self.defaultBond[row].identifier else {
						cell.weightLabel.text = model.defaultTextForBond
						cell.weightLabel.textColor = .systemBlue
						cell.accessoryType = .none
						break
					}
					cell.weightLabel.text = model.bond?.weight?.rawValue
					cell.weightLabel.textColor = .label
					guard model.bond?.weight?.rawValue != nil else {break}
					if userModel?.rawValue == model.bond?.weight?.rawValue {
					cell.accessoryType = .checkmark
				}
				case 1:
					guard currentModel?.identifier == self.defaultText[row].identifier else {
						cell.weightLabel.text = model.defaultTextForText
						cell.weightLabel.textColor = .systemBlue
						cell.accessoryType = .none
						break
					}
					cell.weightLabel.text = model.text?.weight?.rawValue
					cell.weightLabel.textColor = .label
				if userModel?.rawValue == model.text?.weight?.rawValue {
					cell.accessoryType = .checkmark
				}
				case 2:
					guard currentModel?.identifier == self.defaultCover[row].identifier else {
						cell.weightLabel.text = model.defaultTextForCover
						cell.weightLabel.textColor = .systemBlue
						cell.accessoryType = .none
						break
					}
					cell.weightLabel.text = model.cover?.weight?.rawValue
					cell.weightLabel.textColor = .label
				if userModel?.rawValue == model.cover?.weight?.rawValue {
					cell.accessoryType = .checkmark
				}
				default:
					break
				}
			return cell
		})
	}
	
	func returnToNewStock(){
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
			self.performSegue(withIdentifier: SegueIdentifiers.returnToNewStock, sender: self)
		}
	}
}

//MARK: Navigation
extension StockWeight_TableViewController {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.returnToNewStock {
			let destinationController = segue.destination as! NewStock_TableViewController
			
			destinationController.stockWeightLabel.text = userSelectedModel.rawValue
				let stockModel = Stock(nil, nil, userSelectedModel, nil, nil, nil)
			destinationController.updateNewStock(stockModel)
			
		}
	}
}
