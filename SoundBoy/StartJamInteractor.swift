//
//  StartJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol StartJamBusinessLogic
{
  func doSomething(request: StartJam.Submit.Request)
}

protocol StartJamDataStore
{
  //var name: String { get set }
}

class StartJamInteractor: StartJamBusinessLogic, StartJamDataStore
{
  var presenter: StartJamPresentationLogic?
  var worker: StartJamWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: StartJam.Submit.Request)
  {
    worker = StartJamWorker()
    //let jam = request.jam!
    
    //worker?.startJamRequest(jam:jam, completion: { jam in
        
   // })
    
    let response = StartJam.Submit.Response()
    presenter?.presentTexfields(response: response)
  }
}
