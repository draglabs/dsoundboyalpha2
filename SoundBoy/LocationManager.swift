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
  var didGetLocation:((_ location:CLLocation, _ address:Dictionary<String,String>)->())?
  var manager = CLLocationManager()
  
  func requestLocation() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
  
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil {
            lastLocation = locations.last!
            manager.stopUpdatingLocation()
            getAddress()
        }
    }
  
  /// Make sure you set `didGetLocation?()` 
  /// so that youll get the results back
  
    func getAddress() {
    
        if let location = lastLocation {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { (placeMarks, error) in
            guard let places = placeMarks else{return}
            guard  let place = places.first else{return}
            
            
            let street = place.thoroughfare
            let city = place.locality
            let state = place.administrativeArea
            let zipCode = place.postalCode
            self.didGetLocation?(location,["street":street!, "city":city!,"state":state!,"zipcode":zipCode!])
            }
        }
    }
}
