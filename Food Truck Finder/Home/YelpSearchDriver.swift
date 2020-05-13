//
//  YelpSearchDriver.swift
//  Food Truck Finder
//
//  Created by Matthew Hendrickson on 5/13/20.
//  Copyright © 2020 Matt Hendrickson. All rights reserved.
//

import Foundation
import CDYelpFusionKit

class YelpSearchDriver {
    
    private let YelpAPIKey = "MEUh_M8l7apQHZBxo4wGZC3SsRvNwGuWPGKAAdz1rZt3T3mXj3hdy9SeENL5_UUYKebBy3c_Ysc8_cVD-ZCPyRn90Efl8OkKVj3LxzGnh06mJwhcc5roLnoSSE_kXHYx"
    
    private var yelpApiClient: CDYelpAPIClient
    
    init() {
        yelpApiClient = CDYelpAPIClient(apiKey: YelpAPIKey)
    }
    
    //take in a location object
    
    //thats used in a search function that returns a list of businesses
    
    private func handleYLPSearchResult(_ searchResult: CDYelpSearchResponse?) {
        if let businessArray = searchResult?.businesses {
            print(businessArray)
            if let filteredArray = self.filterOutNonFoodTrucks(businessArray) {
                
            } else {
                // TODO: alert no businesses matched your results
            }
            
        } else {
            // TODO: alert. No businesses returned in the array
        }
    }
    
    private func filterOutNonFoodTrucks(_ arrayOfBusinesses:[CDYelpBusiness]) -> [CDYelpBusiness]? {
        
        var foodtrucks:[CDYelpBusiness] = Array()
        
        for business in arrayOfBusinesses {
            
            guard let categories = business.categories else {
                //if a business doesn't have categories listed then ignore it.
                continue
            }
            
            for category in categories {
                //filter out results that dont match correct categories and append to foodtrucks array
            }
        }
        if foodtrucks.count == 0 {
            return nil
        } else {
            return foodtrucks
        }
    }
}
