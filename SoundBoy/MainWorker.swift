//
//  MainWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import Foundation


class MainWorker {
  
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
  
  var startJam = StartJamWorker()
  
  func startJamRequest(completion:@escaping(_ result:Bool)->()) {
   
    userFetcher.fetch {[unowned self] (user, error) in
      if user != nil {
        self.startJam.prepareStartJamRequest(user: user!,completion: completion)
      }
    }
  }
  
  func extiJam(completion:@escaping(_ done:Bool)->()) {
    
  }
  
    
}

