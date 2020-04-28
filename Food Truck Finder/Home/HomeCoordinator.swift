//
//  HomeCoordinator.swift
//  Food Truck Finder
//
//  Created by Matthew Hendrickson on 4/28/20.
//  Copyright © 2020 Matt Hendrickson. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: NSObject {
    
    var navController: UINavigationController?
    var window: UIWindow?

    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        navController = UINavigationController(rootViewController: homeVC)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
    }
}
