//
//  MainInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol MainBusinessLogic
{
  func startJam(request: Main.Jam.Request)
    
}

protocol MainDataStore
{
  var success: Bool { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore
{
  var presenter: MainPresentationLogic?
  var worker: MainWorker?
  
  var success: Bool = false
  // MARK: Do something
  
  func startJam(request: Main.Jam.Request)
  {
    worker = MainWorker()
    worker?.doSomeWork()
    
    let response = Main.Jam.Response()
    presenter?.presentSomething(response: response)
  }
}
