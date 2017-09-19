//
//  JoinJamWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

class JoinJamWorker {
  let user = UserFether()
  let jamDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  
  func joinJam(jamPin:String, completion:@escaping(_ join:Bool)->()) {
    
    user.fetch { (user, error) in
      if user != nil {
        let jamTask = JoinJamOperaion(userId: user!.userId!, jamPin: jamPin)
        jamTask.execute(in: self.jamDispatcher, result: completion)
      }
    }
  }
}

