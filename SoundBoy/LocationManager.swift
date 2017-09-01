//
//  LocationManager.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/14/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreLocation

 class LocationMgr: NSObject,CLLocationManagerDelegate {
    
    
    var lastLocation:CLLocation?
    var manager = CLLocationManager()
    
    func requestLocation() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print("should start updating")
        
    }
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last ?? "")
        if locations.last != nil {
            lastLocation = locations.last!
            manager.stopUpdatingLocation()
        }
    }
    
}
