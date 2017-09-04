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
  var name = ""
  func startJamRequest(completion:@escaping(_ result:String)->()) {
    
    fetcher.fetch { (user, error) in
      
    }
//    let task = StartJamOperation(name: name, location: location)
//    task.execute(in: networkDispatcher) { (done) in
//      
//    }
  }
}
