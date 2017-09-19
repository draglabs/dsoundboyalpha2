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


class StartJamWorker {
  
  let production = Enviroment("production", host: "http://api.draglabs.com/v1.01")
  let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  
  let locationWorker = LocationWorker()
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
  
  
   func prepareStartJamRequest(user:User,completion:@escaping(_ result:Bool)->()) {
    let id = user.userId!
    let name = user.firstName!
    
    locationWorker.didGetLocation = {[unowned self] location, address in
      let date = Data()
      let task = StartJamOperation(userId: id, name:"\(name)-\(String(describing: address["street"]!))", location: "-\(String(describing: address["city"]!))-\(String(describing: date))", coordinates: location.coordinate)
        task.execute(in: self.networkDispatcher, result: completion)
    }
    
    locationWorker.requestLocation()
  }
  
  func checkForExitingJam(completion:@escaping(_ noJam:Bool)->()) {
    jamFetcher.fetch { (jam, error) in
      if jam != nil {
        
      }
    }
  }

}
