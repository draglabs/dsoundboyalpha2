//
//  ShareInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 1/6/18.
//  Copyright (c) 2018 DragLabs. All rights reserved.
//

import UIKit

protocol ShareBusinessLogic
{
  func doSomething(request: Share.Something.Request)
}

protocol ShareDataStore
{
  //var name: String { get set }
}

class ShareInteractor: ShareBusinessLogic, ShareDataStore
{
  var presenter: SharePresentationLogic?
  var worker: ShareWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Share.Something.Request)
  {
    worker = ShareWorker()
    worker?.doSomeWork()
    
    let response = Share.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
