//
//  LocationManager.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/14/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreLocation

 class LocationWorker: NSObject,CLLocationManagerDelegate {
    
    
  var lastLocation:CLLocation?
  var address:CurrentLocation?
  var didGetLocation:((_ location:CLLocation, _ address:CurrentLocation)->())?
  var manager = CLLocationManager()
  
  /// Ask permission and starts
  /// getting the user location
  func requestLocation() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil {
          print("will stop location")
          manager.stopUpdatingLocation()
            lastLocation = locations.last!
            getAddress()
        }
    }
  
  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {}
  
  /// Make sure you set `didGetLocation?()`
  /// so that youll get the results back
    private func getAddress() {
      print("will reverse location")
        if let location = lastLocation {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) {[weak self] (placeMarks, error) in
          print("Reversing location")
            guard let places = placeMarks else{return}
            guard  let place = places.first else{return}
          
            let number = place.subThoroughfare
            let street = place.thoroughfare
            let city = place.locality
            let state = place.administrativeArea
            let zipCode = place.postalCode
          
          let address = CurrentLocation(number: number, street: street!, city: city!, state: state!, zipCode: zipCode!)
            self?.address = address
       
            self?.didGetLocation?(location,address)
            }
        }
    }
  

}
