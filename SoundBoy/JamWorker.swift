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
  
  
  let networkDispatcher = DefaultDispatcher(enviroment:Env().dev)
  let locationWorker = LocationWorker()
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
 
 private func prepareStartJamRequest(user:User,completion:@escaping(_ result:Result<Any>)->()) {
    let id = user.userId!
    let name = user.firstName!
    locationWorker.didGetLocation = {[unowned self] location, address in
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let time = formatter.string(from: date)
      
      let task = StartJamOperation(userId: id, name:"\(name + time)", location: address.number! + address.street, coordinates: location.coordinate)
        task.execute(in: self.networkDispatcher, result: completion)
   }
    locationWorker.requestLocation()
  }
  
 private func checkForExistingJam(completion:@escaping(_ exits:Bool)->()) {
    jamFetcher.fetch { (jam, error) in
      if jam != nil {
        completion(true)
      }else {
        completion(false)
      }
    }
  }
  
  func start(completion:@escaping(_ result:Result<Any>)->()) {
    
    self.checkForExistingJam {[unowned self]  (exits) in
      if !exits {
        self.userFetcher.fetch {(user, error) in
          if user != nil {
            self.prepareStartJamRequest(user: user!,completion: completion)
          }else {
            fatalError("Starting jam but theres no user saved")
          }
        }
      }else {
        completion(Result.failed(message: "Cant start jam", error: nil))
      }
    }
    
  }
 
  func join(jamPin:String, completion:@escaping(_ join:Result<Any>)->()) {
    
     userFetcher.fetch { (user, error) in
      if user != nil {
        let jamTask = JoinJamOperation(userId: user!.userId!, jamPin: jamPin)
        jamTask.execute(in: self.networkDispatcher, result: completion)
      }
    }
  }
  
  func exit(completion:@escaping(Bool)->()) {
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
  
  func update(updates:[String:String?],completion:@escaping(_ join:Result<Any>)->()){
    
  }
  
  func export(jamId:String, completion:@escaping(Result<Any>)->()) {
    
    prepareUser {[unowned self] user in
      let task = ExportJamOperation(userId: user.userId!, jamId: jamId)
      task.execute(in: self.networkDispatcher) { (result) in
        switch result {
        case .success(let succeeded):
          completion(Result.success(data: succeeded))
        case .failed(let message, let error):
          completion(Result.failed(message: message, error: error))
        }
      }
    }
   
  }
  
  private func prepareUser(completion:@escaping(User)->()) {
    let userFetcher = UserFether()
    userFetcher.fetch { (usr, error) in
      if error == nil && usr != nil {
        completion(usr!)
      }
    }
  }
}
