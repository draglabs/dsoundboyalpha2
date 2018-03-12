//
//  SettingsInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol SettingsBusinessLogic
{
  func doSomething(request: Settings.Something.Request)
}

protocol SettingsDataStore
{
  //var name: String { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore
{
  var presenter: SettingsPresentationLogic?
  var worker: SettingsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Settings.Something.Request)
  {
    worker = SettingsWorker()
    worker?.doSomeWork()
    
    let response = Settings.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
