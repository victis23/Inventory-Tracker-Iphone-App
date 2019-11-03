//
//  GoogleMapVenderLocation_ViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/3/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class GoogleMapVenderLocation_ViewController: UIViewController {
	
	private struct Keys {
		static var googleAPI = "AIzaSyBl6VYW1Vh32RDdZ8DUtnmIAvsCw1Icunw"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setGoogleAPIKeys()
    }
	
	
	/// API KEYS PROVIDED BY GOOGLE —
    /// These Keys Might Need to be placed in — App Delegate or Scene File — application(_:didFinishLaunchingWithOptions:)
	
	func setGoogleAPIKeys(){
		GMSServices.provideAPIKey(Keys.googleAPI)
		GMSPlacesClient.provideAPIKey(Keys.googleAPI)
	}

}
