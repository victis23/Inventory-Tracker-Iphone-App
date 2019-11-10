//
//  StockType_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Allows user to select stock weight.
class StockWeight_TableViewController: UITableViewController {
	
	//MARK: Keys
	
	private struct SegueIdentifiers {
		static var returnToNewStock = "weightToHome"
	}
	
	//MARK: Local Data types
	
	// Enum used to create tableview sections.
	private enum Section {
		case bond
		case cover
		case text
	}
	
	// Local StockType Object that will hold the various items in our tableview. Can be initialized StockTypes().
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
	
	//MARK: Private class properties
	
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
	
	//MARK: Class Properties
	
	var userSelectedItem :String!
	var userSelectedModel : Weight?
	var selectedIndex : IndexPath!
	
	//MARK: State
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setDataSource()
    }
	
	//MARK: Class Methods
	// Snapshot is set after view has appeared to avoid placing tableview into memory before it has been placed into the view hierarchy UIWindow.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Bond , Text, Cover
		self.setSnapShot(self.selectOption, self.selectOption2, self.selectOption3, animated: true)
	}
	
	/// Takes the specified catagory of type StockTypes and places it within the corresponding section.
	/// - Parameters:
	///   - bond: Instance of StockTypes using `StockTypes(textForBond:)`
	///   - text: Instance of StockTypes using `StockTypes(textForText:)`
	///   - cover: Instance of StockTypes using `StockTypes(textForCover:)`
	///   - animated: Bool that determines if appearance will be dynamically animated.
	fileprivate func setSnapShot(_ bond:[StockTypes],_ text:[StockTypes], _ cover:[StockTypes], animated:Bool){
		
		var snapShot :NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section,StockTypes>()
		snapShot.appendSections([.bond,.text,.cover])
		snapShot.appendItems(bond, toSection: .bond)
		snapShot.appendItems(text, toSection: .text)
		snapShot.appendItems(cover, toSection: .cover)
		
		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.dataSource.apply(snapShot, animatingDifferences: animated, completion: nil)
		}
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
	
	/// Returns user to tableview that contents the list of required items to create a `Stock` object.
	/// -	Note: This method is only ever called in `tableView(_:didSelectRowAt:)`
	func returnToNewStock(){
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self](timer) in
			self?.performSegue(withIdentifier: SegueIdentifiers.returnToNewStock, sender: self)
		}
	}
	
	//MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.returnToNewStock {
			let destinationController = segue.destination as! NewStock_TableViewController
			guard let userSelectedModel = userSelectedModel else {return}
			destinationController.stockWeightLabel.text = userSelectedModel.rawValue
				let stockModel = Stock(nil, nil, userSelectedModel, nil, nil, nil)
			destinationController.updateNewStock(stockModel)
			
		}
	}
}

//MARK: - Tableview Datasource & Delegate
extension StockWeight_TableViewController {
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//Sets item identifier for item at current indexPath
		guard let identifier = dataSource.itemIdentifier(for: indexPath) else {return}
		// This will always evaluate to a nil value when the tableView loads thus the `else` statement will always run prior to this.
		if identifier.bond?.weight != nil || identifier.text?.weight != nil || identifier.cover?.weight != nil {
			// Runs method once all other actions within scope are completed.
			defer {returnToNewStock()}
			// Checkmarks wont appear for selected item without this reload.
			//Could have used a delegate/protocol but felt lazy, sorry.
			tableView.reloadData()
			// Which ever identifier is != nil will be assigned as the model selected by the user.
			userSelectedModel = identifier.bond?.weight ?? identifier.text?.weight ?? identifier.cover?.weight
		}else{
			let row = indexPath.row
			// Determines which variables will be loaded into the snapshot.
			switch dataSource.itemIdentifier(for: indexPath)?.identifier {
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
	
	func setDataSource(){
		dataSource = Datasource(tableView: tableView, cellProvider: { [weak self](tableView, indexPath, model) -> UITableViewCell? in
			
			let section = indexPath.section
			let row = indexPath.row
			let currentModel = self?.dataSource.itemIdentifier(for: indexPath)
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.weight, for: indexPath) as! StockWeight_TableViewCell
			let userModel = self?.userSelectedModel
			
			switch section {
				case 0:
					guard currentModel?.identifier == self?.defaultBond[row].identifier else {
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
					guard currentModel?.identifier == self?.defaultText[row].identifier else {
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
					guard currentModel?.identifier == self?.defaultCover[row].identifier else {
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
}

