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
import YelpAPI

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
    
    var Yelp:YLPClient!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let LocationManager:CLLocationManager = CLLocationManager.init()
    
    var cityAndState: (String, String)? {
        didSet {
            searchTextField.isEnabled = true
        }
    }
    
    var searchResultsArray:[YLPBusiness]?

    //var searchesArray
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        Yelp = appDelegate.getYelpObject()
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
    
    private func handleYLPSearchResult(_ searchResult: YLPSearch?) {
        if let businessArray = searchResult?.businesses {
            print(businessArray)
            if let filteredArray = self.filterOutNonFoodTrucks(businessArray) {
                self.searchResultsArray = filteredArray
                self.table.reloadData()
                self.addAnnotationsFromArray(businessArray: filteredArray)
            } else {
                // TODO: alert no businesses matched your results
            }
            
        } else {
            // TODO: alert. No businesses returned in the array
        }
    }
    
    private func filterOutNonFoodTrucks(_ arrayOfBusinesses:[YLPBusiness]) -> [YLPBusiness]? {
        var foodtrucks:[YLPBusiness] = Array()
        for business in arrayOfBusinesses {
            for category in business.categories {
                if(category.name == filterFood_Trucks || category.name == filterfoodtruck || category.alias == filterFood_Trucks || category.alias == filterfoodtruck) {
                    foodtrucks.append(business)
                }
            }
        }
        if foodtrucks.count == 0 {
            return nil
        } else {
            return foodtrucks
        }
    }
    
    private func addAnnotationsFromArray(businessArray:[YLPBusiness]!) {
        //reset map annotations
        map.removeAnnotations(map.annotations)
        
        for business in businessArray {
            if let YLPCoordinate = business.location.coordinate {
                let coordinate = CLLocationCoordinate2D.init(latitude: YLPCoordinate.latitude, longitude: YLPCoordinate.longitude)
                let annotation = MKPointAnnotation()
                annotation.title = business.name
                
                annotation.coordinate = CLLocationCoordinate2D.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                map.addAnnotation(annotation)
                
            } else {
                
            }
        }
    }
    
    // MARK: Button Delegates
    @IBAction func tableHeightButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        LocationManager.startUpdatingLocation()
    }
    
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as? SearchResultTableViewCell
        if(cell == nil) {
            cell = SearchResultTableViewCell()
        }
        
        if let business = searchResultsArray?[indexPath.row] {
            cell?.configureWithBusiness(business)
        }
        
        return cell!
    }
    
}

