//
//  VendorLocation_ViewController.swift
//  IphoneInventoryTracker
//
//  Created by Scott Leonard on 11/3/19.
//  Copyright © 2019 Scott Leonard. All rights reserved.
//

import UIKit
import MapKit
import Combine



class VendorLocation_ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var searchBar: UISearchBar!
	let locationController = CLLocationManager()
	var currentRegion : MKCoordinateRegion?
	
	
	let activityIndicator : UIActivityIndicatorView = {
			let activityIndicator = UIActivityIndicatorView()
			activityIndicator.style = .large
			activityIndicator.color = .label
			activityIndicator.hidesWhenStopped = true
			return activityIndicator
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
		locationController.delegate = self
		requestLocationServices()
		activityIndicator.center = view.center
		view.addSubview(activityIndicator)
	}
	func requestLocationServices(){
		locationController.requestWhenInUseAuthorization()
		locationController.requestLocation()
		activityIndicator.startAnimating()
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last?.coordinate else {return}
		let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
		currentRegion(is: region)
		setCurrentMapView(to: currentRegion!)
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	//Sets applications current region global veribal
	func currentRegion(is location: MKCoordinateRegion){
		currentRegion = location
	}
	// Updates Map With Current Region
	func setCurrentMapView(to location :MKCoordinateRegion){
		mapView.setRegion(location, animated: true)
		mapView.showsUserLocation = true
		activityIndicator.stopAnimating()
	}
	func setAnnotation(with annotation : MKPointAnnotation, search : String){
		
		if search != "" {
			mapView.addAnnotation(annotation)
			// Zoom In on Annotation
			let newRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
			mapView.setRegion(newRegion, animated: true)
			activityIndicator.stopAnimating()
		}else{
			//Reset View To Current Location
			guard let currentRegion = currentRegion else {return}
			setCurrentMapView(to: currentRegion)
		}
		
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		//performMapSearch(with: searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else {return}
		performMapSearch(with: searchText)
	}
	
	func performMapSearch(with searchTerm : String){
		activityIndicator.startAnimating()
		let searchQuery = MKLocalSearch.Request()
		searchQuery.resultTypes = .address
		searchQuery.naturalLanguageQuery = searchTerm
		
		let searchRequest = MKLocalSearch(request: searchQuery)
		
		searchRequest.start { [weak self] (response, error) in
			if let error = error {
				print(error.localizedDescription)
			}
			guard let response = response else {return}
			
			//Remove Annotations
			guard let annonations = self?.mapView.annotations else {return}
			self?.mapView.removeAnnotations(annonations)
			
			// Get Values From Response
			let latitude = response.boundingRegion.center.latitude
			let longitude = response.boundingRegion.center.longitude
			
			// Get Address From Response
			response.mapItems.forEach({
				print($0)
			})
			
			// Create Annotation
			
			let newAnnonation = MKPointAnnotation()
			newAnnonation.title = "\(self?.searchBar.text ?? "No Value")"
			//			newAnnonation.coordinate = response.boundingRegion.center
			newAnnonation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
			
			self?.setAnnotation(with: newAnnonation, search: searchTerm)
			
		}
	}
	
	
	
	@IBAction func googleMap(_ sender: Any) {
		present(GoogleMapVenderLocation_ViewController(), animated: true, completion: nil)
	}
	
}

