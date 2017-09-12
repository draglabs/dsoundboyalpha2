//
//  Jamming.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//
import Foundation
import CoreLocation

class StartJamOperation: OperationRepresentable {
  let userId:String
  let jamCoordinates:CLLocationCoordinate2D
  let name:String
  let location:String
  
  var responseError:((_ code:Int?, _ error:Error?)->())?
    
  var store: StoreRepresentable {
    return JamStore()
    }
  
  init(userId:String,name:String, location:String,coordinates:CLLocationCoordinate2D) {
    self.userId = userId
    self.name = name
    self.location = location
    self.jamCoordinates = coordinates
    
    }
  
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ started:Bool)->()) {
        dispatcher.execute(request: request) { (response) in
            
            switch response {
            case .json(let json):
                self.store.fromJSON(json: json, response: result)
            case .data(let data):
                self.store.fromData(data: data, response: result)
            case .error(let status, let error):
                self.responseError?(status, error)
            }
        }
    }

  
    var request: RequestRepresentable {
        
        return JamRequest.start(userId: userId, jamLocation: location, jamName: name, jamCoordinates: jamCoordinates)
    }
  
}
