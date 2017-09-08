//
//  JoinJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol JoinJamBusinessLogic {
  func join(request: JoinJam.Commons.Request)
  func commons(request:JoinJam.Commons.Request)
}

protocol JoinJamDataStore {
  //var name: String { get set }
}

class JoinJamInteractor: JoinJamBusinessLogic, JoinJamDataStore {
  var presenter: JoinJamPresentationLogic?
  var worker: JoinJamWorker?
  //var name: String = ""

  // MARK: Do something
  
  func join(request: JoinJam.Commons.Request) {
    worker = JoinJamWorker()
    //worker?.joinJam(jam: <#T##Jam#>, completion: <#T##() -> ()#>)
    
    let response = JoinJam.Commons.Response()
    presenter?.presentCommons(response: response)
  }
  
  func commons(request: JoinJam.Commons.Request) {
    let response  = JoinJam.Commons.Response()
    presenter?.presentCommons(response: response)
  }
 
 
}
