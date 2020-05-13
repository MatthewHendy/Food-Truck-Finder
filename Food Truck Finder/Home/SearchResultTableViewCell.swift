//
//  SearchResultTableCell.swift
//  Food Truck Finder
//
//  Created by macbook on 5/23/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation
import UIKit
import CDYelpFusionKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var truckImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businessNameLabel.text = ""
        truckImageView.image = nil
    }
    
    func configureWithBusiness(_ business: CDYelpBusiness) {
        if let imageURL = business.imageUrl {
            loadURLIntoImageView(imageURL)
        }
        
        businessNameLabel.text = business.name
    }
    
    private func loadURLIntoImageView(_ imageURL: URL ) {
        DispatchQueue.global().async {
            if let imageURLData = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.truckImageView.image = UIImage(data: imageURLData)
                }
            }
        }
    }
    
    
    
}
