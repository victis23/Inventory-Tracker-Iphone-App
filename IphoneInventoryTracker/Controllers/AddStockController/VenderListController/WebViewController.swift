//
//  WebViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/2/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import WebKit

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
