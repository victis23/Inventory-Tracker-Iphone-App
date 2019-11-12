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

/// Captures string variable for location property that will be passed to delegate --> AddVenderTableViewController.swift.
protocol CompanyAddressDelegate {
	func getCompanyAddress(from location:String)
	func getlocationDetails(at place: GMSPlace)
	func enabledStatusChecker()
}

/// Allows user to find the address of a given company using Google Map Services.
class GoogleMapVenderLocation_ViewController: UIViewController, ObservableObject {
	
	let name = Notification.Name("LocationChanged")
	// The delegate that will save information gathered in this viewController --> AddVenderTableViewController.swift.
	
	//MARK: Class Properties
	
	var delegate : CompanyAddressDelegate? = nil
	
	// Instance of locationManager.
	let locationManager = CLLocationManager()
	
	// Users current location.
	var currentLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
	
	//Search query inputted by user.
	var searchLocation : String = String()
	
	// Returned list of locations resulting from query that will be displayed in tableView.
	var predictedLocations : [GMSPlace] = []
	
	// Location selected by user from tableView.
	var selectedCoordinates : CLLocationCoordinate2D?
	
	// Address that will be set as vender address and returned to AddVendersTableViewController.swift.
	var returnAddress : String = String()
	
	// Creates map object.
	let mapView : GMSMapView = {
		let map = GMSMapView()
		return map
	}()
	
	//MARK: ViewController Views
	
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
	
	let activityIndicator : UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.style = .large
		activityIndicator.color = .black
		activityIndicator.hidesWhenStopped = true
		return activityIndicator
	}()
	
	//MARK: Controller State
	override func loadView() {
		super.loadView()
		guard let currentLocation = currentLocation else {return}
		let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 6)
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		mapView.frame = frame
		mapView.camera = camera
		mapView.isMyLocationEnabled = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
		mapView.delegate = self
		// Layers:
		//4
		view.addSubview(contentView)
		//3
		contentView.addSubview(mapView)
		//2
		view.addSubview(searchBar)
		view.addSubview(submitButton)
		view.addSubview(activityIndicator)
		//1
		setLookOfView()
		setConstraintsForContentView()
		getUserAuthorizationToUseMaps()
	}
	
	//MARK: Methods
	func setLookOfView(){
		view.backgroundColor = .white
		submitButton.isHidden = true
		contentView.layer.cornerRadius = 15
	}
	
	/// Captures users selected location and passes it over to the delegate so it can be used to fill text fields.
	/// - Parameter place: Captured location data.
	func gmsSelectedPlace(is place: GMSPlace){
		delegate?.getlocationDetails(at: place)
	}
	
	/// Setup Contraints for:
	/// `contentView`
	///	`searchBar`
	///	`submitButton`
	func setConstraintsForContentView(){
		//Set position of activity indicator.
		activityIndicator.center = view.center
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			contentView.heightAnchor.constraint(equalToConstant: view.frame.height - 50),
			contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
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
	
	//MARK: Navigation
	
	/// Pops current viewController, returning us to AddVendersTableViewController.swift.
	/// - Calls Methods on delegate to set address and update text property on address label.
	@objc func returnToOriginatingController(){
		delegate?.getCompanyAddress(from: returnAddress)
		delegate?.enabledStatusChecker()
		dismiss(animated: true) {}
		submitButton.isHidden = true
	}
}

//MARK: SearchBar Extension

extension GoogleMapVenderLocation_ViewController : UISearchBarDelegate {
	
	/// Resets values for search query on every iteration.
	/// Sets up user search and sends results to tableview.
	/// - Parameter searchBar: Current SearchBar Object.
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		submitButton.isHidden = true
		guard let searchText = searchBar.text else {return}
		searchLocation = searchText
		// Removes results of previous query.
		predictedLocations.removeAll()
		// Runs query using search term.
		setupPlacesClient()
		searchBar.resignFirstResponder()
		// Presents TableView.
		setupTableView()
	}
}

//MARK: CoreLocation Manager Extension

extension GoogleMapVenderLocation_ViewController : CLLocationManagerDelegate {
	
	/// Set Delegate Property on CLLocationManagerDelegate.
	/// Request when in use authorization from user.
	/// Request users current location.
	func getUserAuthorizationToUseMaps(){
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		activityIndicator.startAnimating()
		locationManager.requestLocation()
	}
	
	/// This Method conforms to CLLocationManagerDelegate & updates GMS CameraPosition  to the users last location.
	/// - Parameters:
	///   - manager: Current CLLocationManager
	///   - locations: Array of locations user has recently been to.
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let updatedLocation = locations.last?.coordinate else {return}
		currentLocation = updatedLocation
		mapView.camera = GMSCameraPosition(latitude: updatedLocation.latitude, longitude: updatedLocation.longitude, zoom: 6)
		activityIndicator.stopAnimating()
	}
	
	/// Handles Erros
	/// - Parameters:
	///   - manager: Current CLLocationManager
	///   - error: Incoming Error
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}

//MARK: TableView Extension

extension GoogleMapVenderLocation_ViewController : UITableViewDelegate, UITableViewDataSource {
	
	/// Counts the number of returned items from GMS Query.
	/// - Parameters:
	///   - tableView: Current tableview instance.
	///   - section: Number of sections in view.
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return predictedLocations.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCell
		let location = predictedLocations[indexPath.row]
		cell.companyName.text = location.name
		cell.companyAddress.text = location.formattedAddress
		cell.addLabelToCell()
		return cell
	}
	
	/// Sets up delegate & dataSource for tableview.
	/// Registers Cell for usage in tableView.
	/// Adds tableview to view as subview with contraints and 100 points reduced from size of view —>  `50 | TableView | 50`
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
		activityIndicator.startAnimating()
		let location = predictedLocations[indexPath.row]
		gmsSelectedPlace(is: location)
		let queryLocation = location.coordinate
		tableView.deselectRow(at: indexPath, animated: true)
		// Updates current mapView with a location indicator over selected user search result.
		updateMapViewWithMarker(to: queryLocation, indexPath: indexPath)
		//Sets controller property for user selected coordinates.
		selectedCoordinates = queryLocation
		// Unwraps addres for location selected by user.
		guard let address = location.formattedAddress else {return}
		// Sets location to controller property that will be sent to delegate.
		returnAddress = address
		tableView.removeFromSuperview()
		submitButton.isHidden = false
	}
}

//MARK: Google Maps Services Extension
extension GoogleMapVenderLocation_ViewController : GMSMapViewDelegate {
	
	// Creates Computed Property {GET} for GMSPlaceClient Instance.
	var googlePlacesClient :GMSPlacesClient {
		get {
			GMSPlacesClient()
		}
	}
	
	/// Performs Query using unique session token for user entered search term.
	func setupPlacesClient(){
		//Unique Session Token.
		let token = GMSAutocompleteSessionToken.init()
		let filter = GMSAutocompleteFilter()
		//Narrow search results to only businesses.
		filter.type = .establishment
		// Switched to background queue to avoid locking UI.
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else {return}
			// Performs query with users actual search term.
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
																		/// Method used to search for our returned GMS placeIDs
																		///This particular method returns all data for placeID vs. `GMSPlacesClient.shared().fetchPlace` which only returns certain values.
																		
																		GMSPlacesClient.shared().lookUpPlaceID(value.placeID) { (place, error) in
																			if let error = error {
																				print(error.localizedDescription)
																			}
																			guard let place = place else {return}
																			// Adds GMS Place Data to our predicted locations array.
																			self.predictedLocations.append(place)
																			// Refreshes tableview with updated list of locations.
																			self.tableView.reloadData()
																		}
																	})
			}
		}
	}
	
	/// Updates the position of GMS MapView Camera utilizing location selected by user in tableview.
	/// - Parameters:
	///   - queryLocation: Coordinates of the search location selected by the user from the tableview.
	///   - indexPath: Index path of last tableview selection.
	func updateMapViewWithMarker(to queryLocation :CLLocationCoordinate2D, indexPath : IndexPath){
		// Location selected from tableview.
		let location = predictedLocations[indexPath.row]
		// Zooms into selected location.
		mapView.camera = GMSCameraPosition(latitude: queryLocation.latitude, longitude: queryLocation.longitude, zoom: 15)
		//Creates Instance For Marker.
		let marker = GMSMarker()
		// Creates a marker in the center of the map for selected address.
		marker.position = queryLocation
		marker.title = location.name
		marker.snippet = location.website?.absoluteString
		marker.map = mapView
		activityIndicator.stopAnimating()
	}
}




