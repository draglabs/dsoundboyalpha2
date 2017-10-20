//
//  LoginInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol LoginBusinessLogic {
  func welcomeText(request: Login.WelcomeText.Request)
  func RegisterUser(request: Login.Register.Request)
}

protocol LoginDataStore {

}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
  var presenter: LoginPresentationLogic?
  var worker: LoginWorker?

  func welcomeText(request: Login.WelcomeText.Request) {
    worker = LoginWorker()
    worker?.requestPermisions()
    
    let response = Login.WelcomeText.Response()
    presenter?.presentText(response: response)
    
  }
    
  func RegisterUser(request: Login.Register.Request) {
     FacebookAPI().loginUser { (result) in
      switch result {
      case .failed(_):
        break
      case .success(_):
        self.presenter?.presentRegisteredUser(response: Login.Register.Response(registered: true))
          }
       }
    }
}
