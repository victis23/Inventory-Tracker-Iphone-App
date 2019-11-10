//
//  ParentSheetSize_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

/// Allows user to select parent sheet size.
class ParentSheetSize_TableViewController: UITableViewController {
	
	//MARK: Keys
	
	private struct SegueIdentifiers {
		static var returnToNewStock = "unwindToNewStock"
	}
	
	//MARK: Local data types
	
	//Sections for tableview.
	private enum Section {
		case paper
		case envelopes
	}
	
	//Local Data type to be held by tableview using different initializers.
	fileprivate struct StockGroupings :Hashable {
		var paper : Stock?
		var envelopes :Stock?
		var defaultTextForPaper :String?
		var defaultTextForEnvelope :String?
		
		init(paper :Stock) {
			self.paper = paper
		}
		init(envelopes :Stock) {
			self.envelopes = envelopes
		}
		init(defaultTextForPaper :String) {
			self.defaultTextForPaper = defaultTextForPaper
		}
		init(defaultTextForEnvelope :String) {
			self.defaultTextForEnvelope = defaultTextForEnvelope
		}
	}
	
	//MARK: Privated class properties
	private var dataSource :Datasource!
	fileprivate var selectPaper = [StockGroupings(defaultTextForPaper: "Select Option")]
	fileprivate var selectEnvelope = [StockGroupings(defaultTextForEnvelope: "Select Option")]
	
	fileprivate var defaultPaperStock :[StockGroupings] = [
		StockGroupings(paper: Stock(nil, ParentSize(rawValue: "8.5 x 11"), nil, nil, nil, nil)),
		StockGroupings(paper: Stock(nil, ParentSize(rawValue: "8.5 x 14"), nil, nil, nil, nil)),
		StockGroupings(paper: Stock(nil, ParentSize(rawValue: "11 x 17"), nil, nil, nil, nil)),
		StockGroupings(paper: Stock(nil, ParentSize(rawValue: "12 x 18"), nil, nil, nil, nil))
	]
	
	fileprivate var defaultEnvelopes : [StockGroupings] = [
		StockGroupings(envelopes: Stock(nil, ParentSize(rawValue: "#9 Envelope"), nil, nil, nil, nil)),
		StockGroupings(envelopes: Stock(nil, ParentSize(rawValue: "#10 Envelope"), nil, nil, nil, nil))
	]
	//MARK: Class Properties
	
	var paperCellIsHidden = true
	var envelopeIsHidden = true
	var userSelectionItem :String!
	var selectedModel : Stock?
	
	//MARK: State
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDataSource()
	}
	
	// Avoid error for placing values onto a tableview that is not within the view hierachy.
	// tableview.window != nil at this point in controller's life cycle.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		createSnapShot(selectPaper, selectEnvelope, animated: true)
	}
	
	//MARK: Methods
	
	fileprivate func setValueLayout(_ model:[StockGroupings], indexPath:IndexPath){
		// This model object is originating from tableView(_:didSelectRowAt:)
		let object = model[indexPath.row]
		var item : Stock?
		// assigns the value of variable: item based on whether the incoming StockGroupings array contains a value for the given property. The default value in this case will always be paper.
		if object.envelopes != nil {
			item = object.envelopes
		}else{
			item = object.paper
		}
		// We assign the string value of the enum type: parentSheetSize
		userSelectionItem = item?.parentSheetSize?.rawValue
		selectedModel = item
		// We reload the data so that the checkmark appears next to the selected item. We could have used a delegate/protocol pattern here but did not out of laziness.
		tableView.reloadData()
		// This is the convoluted part and the reason why we took a different approach to get the same results in the StockWeight_TableViewController.swift.
		//This is only being utilized in the code base to demonstrate the alternative to the approach in the aformentioned.
		Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self](timer) in
			switch item {
				case object.envelopes:
					self?.envelopeIsHidden = true
				case object.paper:
					self?.paperCellIsHidden = true
				default:
					break
			}
			self?.performSegue(withIdentifier: SegueIdentifiers.returnToNewStock, sender: self)
		}
	}
	
	fileprivate func createSnapShot(_ stock : [StockGroupings], _ envelopes : [StockGroupings], animated: Bool){
		var snapShot = NSDiffableDataSourceSnapshot<Section,StockGroupings>()
		snapShot.appendSections([.paper, .envelopes])
		snapShot.appendItems(stock, toSection: .paper)
		snapShot.appendItems(envelopes, toSection: .envelopes)
		
		UIView.animate(withDuration: 0.50) { [weak self] in
			self?.dataSource.apply(snapShot, animatingDifferences: animated, completion: nil)
		}
	}
	
	//MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.returnToNewStock {
			let destination = segue.destination as! NewStock_TableViewController
			destination.sheetSizeLabel.text = userSelectionItem
			
			guard let model = selectedModel else {return}
			destination.updateNewStock(model)
		}
	}
}

//MARK: - TableView DataSource & Delegate Methods
extension ParentSheetSize_TableViewController {
	// Required class if you want to have multiple sections.
	private class Datasource : UITableViewDiffableDataSource<Section,StockGroupings>{
		// Sets title for each section.
		override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
			switch section {
				case 0:
					return "Paper"
				case 1:
					return "Envelopes"
				default:
					return nil
			}
		}
	}
	
	func setDataSource(){
		dataSource = Datasource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, parentSizeObject) ->  UITableViewCell? in
			
			let section = indexPath.section
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.paper, for: indexPath) as! CustomCellTableViewCell
			
			guard let paperCellIsHidden = self?.paperCellIsHidden, let envelopeIsHidden = self?.envelopeIsHidden else {fatalError()}
			// determines which section each value will be placed.
			switch section {
				case 0:
					if paperCellIsHidden {
						cell.nameLabel.text = parentSizeObject.defaultTextForPaper
						cell.nameLabel.textColor = .systemBlue
						cell.accessoryType = .none
						
					}else{
						cell.nameLabel.text = parentSizeObject.paper?.parentSheetSize?.rawValue
						cell.nameLabel.textColor = .label
						if self?.userSelectionItem == parentSizeObject.paper?.parentSheetSize?.rawValue {
							cell.accessoryType = .checkmark
						}else{
							cell.accessoryType = .none
						}
				}
				
				case 1:
					if envelopeIsHidden {
						cell.nameLabel.text = parentSizeObject.defaultTextForEnvelope
						cell.nameLabel.textColor = .systemBlue
						cell.accessoryType = .none
					}else{
						cell.nameLabel.text = parentSizeObject.envelopes?.parentSheetSize?.rawValue
						cell.nameLabel.textColor = .label
						if self?.userSelectionItem == parentSizeObject.envelopes?.parentSheetSize?.rawValue {
							cell.accessoryType = .checkmark
						}else{
							cell.accessoryType = .none
						}
				}
				
				default:
					break
			}
			return cell
		})
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	// A more convoluted and badly written version of StockWeight_Tableview's equivalent method.
	/// Controls which set of values the user sees when the tableview loads and once the first selection is made.
	/// - Parameters:
	///   - tableView: current tableview for controller.
	///   - indexPath: index for item that user selected.
	/// - important: The switch statement always evaluates first when the view has just loaded. This will control what prompts the user sees upon the view loading.
	/// - note: This code is an alternative version to what can be found in `StockWeight_TableViewController`
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Depending on which section was selected the first time snapshot is updated.
		if paperCellIsHidden == false {
			switch indexPath.section {
				case 0:
					setValueLayout(defaultPaperStock, indexPath: indexPath)
				default:
					break
			}
		}else if envelopeIsHidden == false {
			switch indexPath.section {
				case 1:
					setValueLayout(defaultEnvelopes, indexPath: indexPath)
				default:
					break
			}
		}
		let paperSection = IndexPath(row: 0, section: 0)
		let envelopeSection = IndexPath(row: 0, section: 1)
		// Sets default values for the view.
		switch indexPath {
			case paperSection:
				paperCellIsHidden = false
				envelopeIsHidden = true
				createSnapShot(defaultPaperStock, selectEnvelope, animated: true)
			case envelopeSection:
				envelopeIsHidden = false
				paperCellIsHidden = true
				createSnapShot(selectPaper, defaultEnvelopes, animated: true)
			default:
				break
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}

