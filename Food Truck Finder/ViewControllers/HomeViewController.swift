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
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableHeightButton: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var itemsTableView: UITableView!
    
    var Yelp:YLPClient!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //var searchesArray
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        Yelp = appDelegate.getYelpObject()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
    }
    
    
    // MARK: Button Delegates
    @IBAction func tableHeightButtonPressed(_ sender: Any) {
        
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

