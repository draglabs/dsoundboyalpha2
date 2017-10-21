//
//  JoinJamInteractor.swift
//  SoundBoy

//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.


import UIKit

protocol JoinJamBusinessLogic {
  func join(request: JoinJam.Join.Request)
  func commons(request:JoinJam.Commons.Request)
}

protocol JoinJamDataStore {
  var didJoin:Bool { get set }
}

class JoinJamInteractor: JoinJamBusinessLogic, JoinJamDataStore {
  var presenter: JoinJamPresentationLogic?
  var worker: JoinJamWorker?
  let jamWorker = JamWorker()
  let jam = JamFetcher()
  var didJoin: Bool = false
 
  
  func join(request: JoinJam.Join.Request) {
    
    let pin = request.pin
    jamWorker.joinJam(jamPin: pin, completion: { (result) in
      switch result {
      case .failed(_,_):
        DispatchQueue.main.async {
          self.didJoin = false
          self.presenter?.presentDidJoinJam(response: JoinJam.Join.Response(didJoin: false))
        }
      case .success(_):
        DispatchQueue.main.async {
          self.didJoin = true
          self.presenter?.presentDidJoinJam(response: JoinJam.Join.Response(didJoin: true))
        }
      }
      
    })
  }
  
  func commons(request: JoinJam.Commons.Request) {
    let response  = JoinJam.Commons.Response()
    presenter?.presentCommons(response: response)
  
  }
 
 
}
