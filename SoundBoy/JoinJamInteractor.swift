//
//  JoinJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol JoinJamBusinessLogic {
  func join(request: JoinJam.Something.Request)
}

protocol JoinJamDataStore {
  //var name: String { get set }
}

class JoinJamInteractor: JoinJamBusinessLogic, JoinJamDataStore {
  var presenter: JoinJamPresentationLogic?
  var worker: JoinJamWorker?
  //var name: String = ""

  // MARK: Do something
  
  func join(request: JoinJam.Something.Request) {
    worker = JoinJamWorker()
    //worker?.joinJam(jam: <#T##Jam#>, completion: <#T##() -> ()#>)
    
    let response = JoinJam.Something.Response()
    presenter?.presentSomething(response: response)
  }
  
 
 
}
