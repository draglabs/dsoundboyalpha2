//
//  LoginInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol LoginBusinessLogic
{
  func doSomething(request: Login.WelcomeText.Request)
  func RegisterUser(request: Login.Register.Request)
}

protocol LoginDataStore
{
  //var name: String { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore
{
  var presenter: LoginPresentationLogic?
  var worker: LoginWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Login.WelcomeText.Request)
  {
    worker = LoginWorker()
    worker?.doSomeWork()
    
    let response = Login.WelcomeText.Response()
    presenter?.presentSomething(response: response)
  }
    
  func RegisterUser(request: Login.Register.Request) {
     FacebookAPI().loginUser { (done) in
      if done {
        let response = Login.Register.Response(registered: done)
        self.presenter?.presentRegisteredUser(response: response)
         }
       }
    }
}