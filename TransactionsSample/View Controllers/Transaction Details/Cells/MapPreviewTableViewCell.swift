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
    
    override func prepareForReuse() {
        ibAddressLabel.text = "Loading..."
    }
    
    func configure(with item: Transaction, at indexPath: IndexPath) {
        if let coordinates = item.coordinates {
            
            let newPin = MKPointAnnotation()
            newPin.coordinate = coordinates
            ibMapView.addAnnotation(newPin)
            
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
    /**
    This should be optimized to load only once per coordinate and ideally save the value in Realm.
    The address string will never change after reverse geocoding it.
     **/
    func findAddress(item: Transaction, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {

        if let coordinate = item.coordinates {
            let geocoder = CLGeocoder()
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                
                let firstLocation = placemarks?.first
                completionHandler(firstLocation)
            })
            
        } else {
            completionHandler(nil)
        }
    }
}
