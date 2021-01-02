//
//  LocationCell.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
	let companyName: UILabel = {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .systemRed
		label.font = .systemFont(ofSize: 15, weight: .bold)
		return label
	}()
	
	let companyAddress: UILabel = {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 19, weight: .regular)
		label.clipsToBounds = true
		return label
	}()
	
	func addLabelToCell() {
		contentView.addSubview(companyName)
		contentView.addSubview(companyAddress)
		addLabelConstraints()
	}
	
	func addLabelConstraints() {
		companyName.translatesAutoresizingMaskIntoConstraints = false
		companyAddress.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			companyName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
			companyName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			companyName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			companyAddress.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 5),
			companyAddress.leadingAnchor.constraint(equalTo: companyName.leadingAnchor),
			companyAddress.trailingAnchor.constraint(equalTo: companyName.trailingAnchor),
			companyAddress.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			companyAddress.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
		])
	}
}
