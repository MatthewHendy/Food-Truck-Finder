//
//  LocationController.swift
//  Food Truck Finder
//
//  Created by macbook on 5/22/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject {
    private var city: String?
    private var state: String?
    private var location:CLLocation?
    
    
    required init?(loc:CLLocation?) {
        super.init()
        
        guard let loc = loc
            else {
                return nil
        }
        
        location = loc
        
        let geocoder:CLGeocoder = CLGeocoder.init()
        
        
        geocoder.reverseGeocodeLocation(location!) { (arrayOfResults, error) in
            if let placemark = arrayOfResults?[0] {
                self.city = placemark.locality
                self.state = placemark.administrativeArea
            } else {
                //show error
                print("cant find the placemark")
            }
        }
    }
    
    open func getLatitude() -> CLLocationDegrees? {
        if let lat = location?.coordinate.latitude {
            return lat
        } else {
            return nil
        }
    }
    
    open func getLongitude() -> CLLocationDegrees? {
        if let long = location?.coordinate.longitude {
            return long
        } else {
            return nil
        }
    }
    
    open func getCity() -> String? {
        return city
    }
    
    open func getState() -> String? {
        return state
    }
}
