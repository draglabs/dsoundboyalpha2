//
//  StartJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol StartJamBusinessLogic {
  func textfields(request: StartJam.Textfields.Request)
  func submitJam(request:StartJam.Submit.Request)
  func successStart(request:StartJam.Success.Request)
}

protocol StartJamDataStore {
 var success: Bool { get set }
}

class StartJamInteractor: StartJamBusinessLogic, StartJamDataStore {
  var presenter: StartJamPresentationLogic?
  var worker: StartJamWorker?
  var success: Bool = false
  
  // MARK: Logic
  
  func textfields(request: StartJam.Textfields.Request) {
    let response = StartJam.Textfields.Response()
    presenter?.presentTexfields(response: response)
  }
    
    func submitJam(request: StartJam.Submit.Request) {
        worker = StartJamWorker()
        worker?.startJamRequest(name: request.name, location: request.location, completion: { (id) in
            
        })
//        if let jam = request.jam {
//            print(jam)
//            worker?.startJamRequest(jam:jam, completion: { id in
//                self.presenter?.presentJam(response: StartJam.Submit.Response(jam: jam))
//            })
//        }
    }
    
 func successStart(request: StartJam.Success.Request) {
    let success = request.success
    let response = StartJam.Success.Response(success: success)
    presenter?.presentSuccess(response: response)
        
    }
}
