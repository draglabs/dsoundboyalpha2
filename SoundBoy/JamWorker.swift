//
//  Jamming.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//
import Foundation
import CoreLocation

class JamWorker {
  
  let production = Enviroment("production", host: "http://api.draglabs.com/v1.01")
  let networkDispatcher = DefaultDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  
  let locationWorker = LocationWorker()
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
 
 private func prepareStartJamRequest(user:User,completion:@escaping(_ result:Bool)->()) {
    let id = user.userId!
    let name = user.firstName!
    
    locationWorker.didGetLocation = {[unowned self] location, address in
      let date = Data()
      let task = StartJamOperation(userId: id, name:"\(name)-\(String(describing: address["street"]!))", location: "-\(String(describing: address["city"]!))-\(String(describing: date))", coordinates: location.coordinate)
        task.execute(in: self.networkDispatcher, result: completion)
   }
    locationWorker.requestLocation()
  }
  
 private func checkForExitingJam(completion:@escaping(_ exits:Bool)->()) {
    jamFetcher.fetch { (jam, error) in
      if jam != nil {
        completion(true)
      }else {
        completion(false)
      }
    }
  }
  
  func startJam(completion:@escaping(_ result:Bool)->()) {
    
    self.checkForExitingJam {[unowned self]  (exits) in
      if !exits {
        self.userFetcher.fetch {(user, error) in
          if user != nil {
            self.prepareStartJamRequest(user: user!,completion: completion)
          }else {
            fatalError("Starting jam but theres no user saved")
          }
        }
      }else {
        completion(false)
      }
    }
    
  }
 
  func joinJam(jamPin:String, completion:@escaping(_ join:Bool)->()) {
    
     userFetcher.fetch { (user, error) in
      if user != nil {
        let jamTask = JoinJamOperation(userId: user!.userId!, jamPin: jamPin)
        jamTask.execute(in: self.networkDispatcher, result: completion)
      }
    }
  }
  
  func exitJam(completion:@escaping(Bool)->()) {
    userFetcher.fetch { (user, error) in
      if user != nil {
        let id = user!.userId!
        self.prepareForExitingJam(userId: id, completion: completion)
      }
    }
  }
  
  private func prepareForExitingJam(userId:String, completion:@escaping(Bool)->()) {
      jamFetcher.fetch {[unowned self] (jam, error) in
        if jam != nil {
          let jamId = jam!.id!
          let exitOperation = ExitJamOperation(userId:userId, jamId: jamId)
          exitOperation.execute(in: self.networkDispatcher, result: completion)
        }
      }
  }
  
}
