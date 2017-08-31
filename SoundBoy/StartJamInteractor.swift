//
//  StartJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol StartJamBusinessLogic {
  func textfields(request: StartJam.Submit.Request)
  func startJam(request:StartJam.Submit.Request)
  func successStart(request:StartJam)
}

protocol StartJamDataStore {
 var success: Bool { get set }
}

class StartJamInteractor: StartJamBusinessLogic, StartJamDataStore {
  var presenter: StartJamPresentationLogic?
  var worker: StartJamWorker?
  var success: Bool = false
  
  // MARK: Logic
  
  func textfields(request: StartJam.Submit.Request) {
    let response = StartJam.Submit.Response()
    presenter?.presentTexfields(response: response)
  }
    
    func startJam(request: StartJam.Submit.Request) {
        worker = StartJamWorker()
        if let jam = request.jam {
            worker?.startJamRequest(jam:jam, completion: { jam in
                
            })
        }
    }
    
    func successStart(request: StartJam) {
        
    }
}
