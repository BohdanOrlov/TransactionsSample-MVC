//
//  MapPreviewTableViewCell.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 26/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class MapPreviewTableViewCell: UITableViewCell, Reusable, ConfigurableCell  {
    typealias T = Transaction
    
    @IBOutlet weak var ibAddressLabel: PaddingLabel!
    @IBOutlet weak var ibMapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        ibAddressLabel.text = "Loading..."
    }
    
    func configure(with item: Transaction, at indexPath: IndexPath) {
        if let coordinates = item.coordinates {
            let region = ibMapView.regionThatFits(MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000))
            ibMapView.setRegion(region, animated: true)
            
            findAddress(item: item) { [weak self] location in
                guard let `self` = self else { return }
                
                self.ibAddressLabel.text = CNPostalAddressFormatter.string(from:location?.postalAddress ?? CNPostalAddress(), style: .mailingAddress).replacingOccurrences(of: "\n", with: ", ")
            }
        }
        
    }
}

extension MapPreviewTableViewCell {
    func findAddress(item: Transaction, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let location = item.coordinates {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
