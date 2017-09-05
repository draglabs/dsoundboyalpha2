//
//  MainWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import CoreData




class MainWorker {
  let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  let fetcher = UserFether()
  let locationMgr = LocationMgr()
  
  
  
  func startJamRequest(completion:@escaping(_ result:Bool)->()) {
   
    fetcher.fetch {[unowned self] (user, error) in
      if user != nil {
       self.prepareRequest(user: user!,completion: completion)
        
      }
    }

  }
 private func prepareRequest(user:User,completion:@escaping(_ result:Bool)->()) {
    let id = user.userId!
    let name = user.firstName!
  
  locationMgr.didGetLocation = { location, address in
    
      let task = StartJamOperation(userId: id, name:"\(name)-\(String(describing: address["street"]!))", location: "\(String(describing: address["city"]!))", coordinates: location.coordinate)
      task.execute(in: self.networkDispatcher, result: { (done) in
        completion(done)
      })
    }
    locationMgr.requestLocation()
  }
  
  
  func addressResponse() {
    
  }
}
