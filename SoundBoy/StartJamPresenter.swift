//
//  StartJamPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol StartJamPresentationLogic
{
  func presentTexfields(response: StartJam.Submit.Response)
}

class StartJamPresenter: StartJamPresentationLogic
{
  weak var viewController: StartJamDisplayLogic?
  
  // MARK: Do something
  
  func presentTexfields(response: StartJam.Submit.Response) {
    let viewModel = StartJam.Submit.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
