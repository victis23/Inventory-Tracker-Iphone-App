//
//  VenderContactInfo_TableViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 10/6/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import WebKit
import MessageUI
import SafariServices
import CoreTelephony

class VenderContactInfo_TableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, WebViewDelegate, SFSafariViewControllerDelegate {
	
	var websiteURL: URL? = URL(string: "http://www.google.com")
	
	
	@IBOutlet weak var supplierName :UILabel!
	@IBOutlet weak var phoneNumberLabel : UILabel!
	@IBOutlet weak var emailAddressLabel : UILabel!
	@IBOutlet weak var physicalAddressLine1Label : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe2 : UILabel!
	@IBOutlet weak var physicalAddressLine1Labe3 : UILabel!
	@IBOutlet weak var websiteLabel : UILabel!
	
	var contactInformation : VenderInfo!
	//Index Paths
	let phoneNumberIndexPath = IndexPath(row: 0, section: 1)
	let emailIndexPath = IndexPath(item: 1, section: 1)
	let websiteIndexPath = IndexPath(item: 3, section: 1)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setvaluesForVender()
		
	}
	
	func setvaluesForVender(){
		supplierName.text = contactInformation.name.rawValue
		phoneNumberLabel.text = contactInformation.phone
		emailAddressLabel.text = contactInformation.email
		
		guard let website = contactInformation.website else {return}
		websiteLabel.text = "\(website)"
		
		let address = contactInformation.address.split(separator: ",")
		physicalAddressLine1Label.text = String(address[0])
		physicalAddressLine1Labe2.text = String(address[1])
		physicalAddressLine1Labe3.text = "\(address[2]), \(address[3])"
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath {
			case phoneNumberIndexPath:
				if let url = URL(string: "tel://\(contactInformation.phone)"){
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
			
			case emailIndexPath:
				sendEmail()
			case websiteIndexPath:
				/* Not In use because of current bug in iOS 13.2*/
								loadWebView()
				
//				let safariViewer = SFSafariViewController(url: contactInformation.website!)
//				safariViewer.modalPresentationStyle = .pageSheet
//				present(safariViewer, animated: true, completion: nil)
			default:
				break
		}
	}
	
	func sendEmail(){
		let mailComposure = MFMailComposeViewController()
		mailComposure.mailComposeDelegate = self
		
		if MFMailComposeViewController.canSendMail() {
			mailComposure.setToRecipients([contactInformation.email])
			mailComposure.setSubject("Messaged Issued From Inventory Tracker App:")
			present(mailComposure, animated: true)
		}else{
			let alertController = UIAlertController(title: "Error",
													message: "Device Does Not Support Email",
													preferredStyle: .alert)
			let accept = UIAlertAction(title: "Accept",
									   style: .default,
									   handler: nil)
			alertController.addAction(accept)
			alertController.preferredAction = accept
			present(alertController, animated: true, completion: nil)
		}
	}
	
	func loadWebView(){
		let webViewController = WebViewController()
		webViewController.delegate = self
		websiteURL = contactInformation.website
		present(webViewController, animated: true, completion: nil)
	}
	
}




protocol WebViewDelegate {
	var websiteURL : URL? {get set}
}

class WebViewController : UIViewController, WKUIDelegate {
	
	var delegate : WebViewDelegate?
	var browser : WKWebView!
	
	override func loadView() {
		super.loadView()
		let configuration = WKWebViewConfiguration()
		browser = WKWebView(frame: .zero, configuration: configuration)
		browser.uiDelegate = self
		view = browser
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.yellow
		setupSession()
	}
	
	func setupSession(){
		
		guard let url = delegate?.websiteURL else {return}
		print(url)
		let urlRequest = URLRequest(url: url)
			browser.load(urlRequest)
	}
}
