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
    
    let filterFood_Trucks = "Food Trucks"
    let filterfoodtruck = "foodtrucks"
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableHeightButton: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var Yelp:YLPClient!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let LocationManager:CLLocationManager = CLLocationManager.init()
    var currentLocation:Location!
    
    var searchResultsArray:[YLPBusiness]?

    //var searchesArray
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        Yelp = appDelegate.getYelpObject()
        LocationManager.delegate = self
        
        LocationManager.requestWhenInUseAuthorization()
        
        LocationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
    }
    
    // MARK: Location Manager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last
        else {
            //show an error?
            // TODO add Alert couldnt get location from location manager
            print("couldnt get location from location manager")
            return
        }

        if let loc = Location.init(loc: location) {
            currentLocation = loc
            
            guard let currentLocLat = currentLocation.getLatitude()
                else {
                    // TODO: add alert couldnt unwrap the latitude
                    print("couldnt unwrap the latitude")
                    return
            }
            
            guard let currentLocLong = currentLocation.getLongitude()
                else {
                    // TODO: add alert couldnt unwrap the longitude
                    print("couldnt unwrap the longitude")
                    return
            }

            self.setMainAreaOnMap(currentLocLat, currentLocLong)
            LocationManager.stopUpdatingLocation()//only need current location. no need to track movements
        } else {
            // TODO: add alert couldnt init the Location object after passing in the CLLocation
            print("couldnt init the Location object after passing in the CLLocation")
        }
        
        
    }
    
    private func setMainAreaOnMap(_ latitude: CLLocationDegrees, _ longitude:CLLocationDegrees) {
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        map.setCenter(CLLocationCoordinate2DMake(latitude, longitude), animated: true)
        
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan.init(latitudeDelta: CLLocationDegrees.init(0.5), longitudeDelta: CLLocationDegrees.init(0.5))
        let region = MKCoordinateRegion.init(center: center, span: span)
        map.setRegion(region, animated: true)
        
    }
    
    private func reloadTableAndAddAnnotationsToMap() {
        table.reloadData()
        
    }
    
    private func addAnnotationsToMap() {
        
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            var searchLocation:String
            
            if let city = currentLocation.getCity(), let state = currentLocation.getState() {
                searchLocation = "\(city), \(state)"
            } else if let city = currentLocation.getCity() {
                searchLocation = city
            } else if let state = currentLocation.getState() {
                searchLocation = state
            } else {
                searchLocation = ""
            }

            print("\(searchLocation)")
            Yelp?.search(withLocation: searchLocation, term: searchText, limit: 50, offset: 0, sort: YLPSortType.bestMatched) { (searchResult, error) in
                if(error != nil) {
                    
                } else {
                    self.handleYLPSearchResult(searchResult)
                }
            }
            
        } else {
            //TODO: must enter text alert
        }
        
        return true
    }
    
    private func handleYLPSearchResult(_ searchResult: YLPSearch?) {
        if let businessArray = searchResult?.businesses {
            if let filteredArray = self.filterOutNonFoodTrucks(businessArray) {
                self.searchResultsArray = filteredArray//TODO: figure out weak self
                self.reloadTableAndAddAnnotationsToMap()
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
    
    // MARK: Button Delegates
    @IBAction func tableHeightButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        LocationManager.startUpdatingLocation()
    }
    
    
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        return cell
    }
    
}

