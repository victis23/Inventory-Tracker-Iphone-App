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
import Combine


class GoogleMapVenderLocation_ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, ObservableObject {
	
	let locationManager = CLLocationManager()
	var currentLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
	
	let name = Notification.Name("LocationChanged")
	//Search query inputted by user.
	var searchLocation : String = String()
	// Returned list of locations resulting from query.
	var predictedLocations : [GMSPlace] = []
	// Address that will be set as vender address
	@Published var returnAddress : String = String()
	
	var selectedCoordinates : CLLocationCoordinate2D?
	var controller = AddVendersTableViewController()
	 
	// Creates map object.
	let mapView : GMSMapView = {
		let map = GMSMapView()
		return map
	}()
	// Creates content spacing on main view.
	let contentView : UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.backgroundColor = UIColor.white.cgColor
		return view
	}()
	// Creates search field
	let searchBar : UISearchBar = {
		let searcher = UISearchBar()
		searcher.barStyle = .default
		searcher.searchBarStyle = .minimal
		searcher.translatesAutoresizingMaskIntoConstraints = false
		searcher.enablesReturnKeyAutomatically = true
		searcher.searchTextField.textColor = .black
		searcher.backgroundColor = .white
		searcher.alpha = 0.85
		searcher.layer.cornerRadius = 15
		searcher.layer.shadowOpacity = 0.6
		searcher.layer.shadowOffset = CGSize(width: 0, height: 5)
		searcher.layer.shadowRadius = 8
		return searcher
	}()
	let tableView : UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .white
		tableView.layer.cornerRadius = 15
		tableView.layer.shadowOpacity = 1.0
		tableView.layer.shadowOffset = CGSize(width: 5, height: 5)
		return tableView
	}()
	let submitButton : UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Save", for: .normal)
		button.backgroundColor = .white
		button.layer.cornerRadius = 15
		button.tintColor = .black
		button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
		button.setTitleColor(.systemBlue, for: .normal)
		button.addTarget(self, action: #selector(returnToOriginatingController), for: .touchUpInside)
		button.layer.shadowOpacity = 0.6
		button.layer.shadowOffset = CGSize(width: 0, height: 5)
		button.layer.shadowRadius = 5
		return button
	}()
	
	override func loadView() {
		super.loadView()
		guard let currentLocation = currentLocation else {return}
		let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 6)
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.size.height - 50)
		mapView.frame = frame
		mapView.camera = camera
		mapView.isMyLocationEnabled = true
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setLookOfView()
		getUserAuthorizationToUseMaps()
		view.addSubview(contentView)
		contentView.addSubview(mapView)
		view.addSubview(searchBar)
		view.addSubview(submitButton)
		setConstraintsForContentView()
		searchBar.delegate = self
		mapView.delegate = self
		submitButton.isHidden = true
		
		
		//MARK: Temp
		controller.delegate = self
		NotificationCenter.default.post(name: name, object: returnAddress) // Working on getting this to send notification correctly.
	}
	func setConstraintsForContentView(){
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
			contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			
			searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
			searchBar.heightAnchor.constraint(equalToConstant: 70),
			searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 10),
			searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
			submitButton.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
			submitButton.heightAnchor.constraint(equalToConstant: 70)
		])
	}
	func setLookOfView(){
		view.backgroundColor = .white
	}
	func getUserAuthorizationToUseMaps(){
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let updatedLocation = locations.last?.coordinate else {return}
		currentLocation = updatedLocation
		mapView.camera = GMSCameraPosition(latitude: updatedLocation.latitude, longitude: updatedLocation.longitude, zoom: 6)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	
}

extension GoogleMapVenderLocation_ViewController {
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		submitButton.isHidden = true
		guard let searchText = searchBar.text else {return}
		searchLocation = searchText
		predictedLocations.removeAll() // Removes results of previous query.
		setupPlacesClient() // Runs query using search term
		searchBar.resignFirstResponder()
		setupTableView() // Presents TableView
	}
}

extension GoogleMapVenderLocation_ViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return predictedLocations.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCell
		cell.companyName.text = predictedLocations[indexPath.row].name
		cell.companyAddress.text = predictedLocations[indexPath.row].formattedAddress
		cell.addLabelToCell()
		return cell
	}
	func setupTableView(){
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(LocationCell.self, forCellReuseIdentifier: "cell")
		tableView.reloadData()
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.heightAnchor.constraint(equalToConstant: 300),
			tableView.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
			tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let queryLocation = predictedLocations[indexPath.row].coordinate
		
		tableView.deselectRow(at: indexPath, animated: true)
		updateMapViewWithMarker(to: queryLocation, indexPath: indexPath)
		selectedCoordinates = queryLocation
		returnAddress = predictedLocations[indexPath.row].formattedAddress!
		//MARK: Temp Code Block
		tableView.removeFromSuperview()
		submitButton.isHidden = false
	}
	@objc func returnToOriginatingController(){
		dismiss(animated: true) { [weak self] in
			self?.controller.enabledStatusChecker()
			print("This is the initiated view controller — \(String(describing: self?.controller))")
		}
		submitButton.isHidden = true
	}
	func updateMapViewWithMarker(to queryLocation :CLLocationCoordinate2D, indexPath : IndexPath){
		mapView.camera = GMSCameraPosition(latitude: queryLocation.latitude, longitude: queryLocation.longitude, zoom: 15)
		mapView.animate(toLocation: queryLocation)
		// Creates a marker in the center of the map for selected address
		let marker = GMSMarker()
		marker.position = queryLocation
		marker.title = predictedLocations[indexPath.row].name
		marker.snippet = predictedLocations[indexPath.row].website?.absoluteString
		marker.map = mapView
	}
}

extension GoogleMapVenderLocation_ViewController : GMSMapViewDelegate {
	
	
	var googlePlacesClient :GMSPlacesClient {
		get {
			GMSPlacesClient()
		}
	}
	
	func setupPlacesClient(){
		let token = GMSAutocompleteSessionToken.init()
		let filter = GMSAutocompleteFilter()
		filter.type = .establishment
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else {return}
			self.googlePlacesClient.findAutocompletePredictions(fromQuery: self.searchLocation,
																bounds: nil,
																boundsMode: GMSAutocompleteBoundsMode.bias,
																filter: filter,
																sessionToken: token) { (predictions, error) in
																	
																	guard error == nil else {
																		print(error!.localizedDescription)
																		return
																	}
																	guard let predictions = predictions else {return}
																	predictions.forEach({ (value) in
																	
																		GMSPlacesClient.shared().lookUpPlaceID(value.placeID) { (place, error) in
																			if let error = error {
																				print(error.localizedDescription)
																			}
																			guard let place = place else {return}
																			self.predictedLocations.append(place)
																			self.tableView.reloadData()
																		}
																	})
			}
			
		}
		
	}
	
	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
		print("didTapInfoWindowOf")
	}
}

extension GoogleMapVenderLocation_ViewController : CompanyAddressDelegate {

	func getCompanyAddress() -> String {
		return returnAddress
	}
}
