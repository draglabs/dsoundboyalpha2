//
//  LoginPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol LoginPresentationLogic
{
  func presentSomething(response: Login.WelcomeText.Response)
  func presentRegisteredUser(response:Login.Register.Response)
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Login.WelcomeText.Response) {
    let viewModel = Login.WelcomeText.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }

  func presentRegisteredUser(response: Login.Register.Response) {
    let viewModel = Login.Register.ViewModel(registered: response.registered)
    viewController?.displayMainScreen(viewModel: viewModel)
  }
}
