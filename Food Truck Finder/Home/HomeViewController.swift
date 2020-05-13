//
//  HomeViewController.swift
//  Food Truck Finder
//
//  Created by macbook on 5/15/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    
    private let filterFood_Trucks = "Food Trucks"
    private let filterfoodtruck = "foodtrucks"
    private let searchResultCell = "searchResultCell"
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableHeightButton: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let LocationManager:CLLocationManager = CLLocationManager.init()
    
    var cityAndState: (String, String)? {
        didSet {
            searchTextField.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        LocationManager.delegate = self
        
        LocationManager.requestWhenInUseAuthorization()
        
        table.register(UINib.init(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: searchResultCell)
        
        self.searchTextField.isEnabled = false
        self.navigationItem.title = "Food Truck Finder"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        LocationManager.startUpdatingLocation()
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    // MARK: Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        setMainAreaOnMap(location.coordinate.latitude, location.coordinate.longitude)
        
        let geocoder:CLGeocoder = CLGeocoder.init()
        
        geocoder.reverseGeocodeLocation(location) { (arrayOfResults, error) in
            if let placemark = arrayOfResults?[0],
                let city = placemark.locality,
                let state = placemark.administrativeArea {
                
                self.cityAndState = (city, state)
                manager.stopUpdatingLocation()
            } else {
                //show error
                print("cant find the placemark, city or state")
            }
        }
    }
    
    private func setMainAreaOnMap(_ latitude: CLLocationDegrees, _ longitude:CLLocationDegrees) {
        map.setCenter(CLLocationCoordinate2DMake(latitude, longitude), animated: true)
        
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: CLLocationDegrees.init(0.5), longitudeDelta: CLLocationDegrees.init(0.5))
        let region = MKCoordinateRegion.init(center: center, span: span)
        map.setRegion(region, animated: true)
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    // MARK: Button Delegates
    @IBAction func tableHeightButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        LocationManager.startUpdatingLocation()
    }
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//pull from viewModel created by search result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as? SearchResultTableViewCell
        if(cell == nil) {
            cell = SearchResultTableViewCell()
        }
        
        //get a HomeVCSearchResultViewModel from searchResult ViewModel
//        if let business =  {
//            cell?.configureWithBusiness(business)
//        }
        
        return cell!
    }
    
}

