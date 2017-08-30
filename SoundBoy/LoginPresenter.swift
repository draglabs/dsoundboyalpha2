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
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Login.WelcomeText.Response)
  {
    let viewModel = Login.WelcomeText.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
