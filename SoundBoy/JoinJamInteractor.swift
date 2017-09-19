//
//  JoinJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol JoinJamBusinessLogic {
  func join(request: JoinJam.Join.Request)
  func commons(request:JoinJam.Commons.Request)
}

protocol JoinJamDataStore {
  var didJoin:Bool {get set}
}

class JoinJamInteractor: JoinJamBusinessLogic, JoinJamDataStore {
  var presenter: JoinJamPresentationLogic?
  var worker: JoinJamWorker?
  let jam = JamFetcher()
  var didJoin: Bool = false
 
  
  func join(request: JoinJam.Join.Request) {
    worker = JoinJamWorker()
    let pin = request.pin
    worker?.joinJam(jamPin: pin, completion: { (didJoin) in
      print("did Join \(didJoin)")
      
    })
    let response = JoinJam.Commons.Response()
    //presenter?.presentCommons(response: response)
  }
  
  func commons(request: JoinJam.Commons.Request) {
    let response  = JoinJam.Commons.Response()
    presenter?.presentCommons(response: response)
  
  }
 
 
}
