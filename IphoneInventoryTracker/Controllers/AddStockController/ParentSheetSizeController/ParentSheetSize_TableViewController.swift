//
//  ParentSheetSize_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class ParentSheetSize_TableViewController: UITableViewController {
	
	private struct SegueIdentifiers {
		static var returnToNewStock = "unwindToNewStock"
	}
	
	private enum Section {
		case paper
		case envelopes
	}
	
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
	
	private var dataSource :Datasource!
	var paperCellIsHidden = true
	var envelopeIsHidden = true
	var userSelectionItem :String!
	var selectedModel : Stock?

	
	fileprivate func setValueLayout(_ model:[StockGroupings], indexPath:IndexPath){

		let object = model[indexPath.row]
		var item : Stock?
		
		if object.envelopes != nil {
			item = object.envelopes
		}else{
			item = object.paper
		}
		
		userSelectionItem = item?.parentSheetSize?.rawValue
		selectedModel = item
		tableView.reloadData()
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

    override func viewDidLoad() {
        super.viewDidLoad()
		setDataSource()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//Temporary fix until I figure out tableview.window != nil
		createSnapShot(selectPaper, selectEnvelope, animated: true)
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
	
	func setDataSource(){
		dataSource = Datasource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, parentSizeObject) ->  UITableViewCell? in
			
			let section = indexPath.section
			let cell = tableView.dequeueReusableCell(withIdentifier: Keys.paper, for: indexPath) as! CustomCellTableViewCell
			
			guard let paperCellIsHidden = self?.paperCellIsHidden, let envelopeIsHidden = self?.envelopeIsHidden else {fatalError()}
			
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
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
	
	private class Datasource : UITableViewDiffableDataSource<Section,StockGroupings>{
		
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

