//
//  StartJamWorker.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

class StartJamWorker {
    let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
    
    func startJamRequest(name:String,location:String,completion:@escaping(_ result:String)->()) {
        
//        let task = Star
//        task.execute(in: networkDispatcher) { (jam) in
//            
//        }
  }
}
