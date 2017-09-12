//
//  MainWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import Foundation


class MainWorker {
  let production = Enviroment("production", host: "http://api.draglabs.com/v1.01")
  
  let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
  let locationMgr = LocationWorker()
  var uploadDelegate:JamUpLoadNotifier?
  
  
  func startJamRequest(completion:@escaping(_ result:Bool)->()) {
   
    userFetcher.fetch {[unowned self] (user, error) in
      if user != nil {
       self.prepareStartJamRequest(user: user!,completion: completion)
        
      }
    }

  }
  
 private func prepareStartJamRequest(user:User,completion:@escaping(_ result:Bool)->()) {
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
  
  

  func uploadJam(url:URL, delegate:JamUpLoadNotifier) {
    self.uploadDelegate = delegate
    
    userFetcher.fetch { (user, error) in
      if user != nil {
        self.prepareUser(user: user!,url: url)
        }
     }
    
  }
  
  func prepareUser(user:User, url:URL) {
    let userId = user.userId!
    
    jamFetcher.fetch { (jam, error) in
      if jam != nil {
        self.prepareJam(jam: jam!, userId: userId, url:url)
      }
    }
    
 }
  
  func prepareJam(jam:Jam,userId:String, url:URL) {
      let uploadDispatcher = JamUpLoadDispatcher(enviroment:production, fileURL: url, delegate: uploadDelegate!)
      let task = JamUpload(userId: userId, jam: jam, isSolo: false)
      task.executeUpload(in: uploadDispatcher)
  }
    
}

