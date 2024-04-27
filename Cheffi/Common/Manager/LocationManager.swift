//
//  LocationManager.swift
//  Cheffi
//
//  Created by 김문옥 on 3/30/24.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    override init() {
        super.init()
        
        delegate = self
        requestWhenInUseAuthorization()
        startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            
//            print("위도: \(latitude), 경도: \(longitude)")
        }
    }
}
