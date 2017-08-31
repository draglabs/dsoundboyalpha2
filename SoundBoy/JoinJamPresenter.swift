//
//  JoinJamPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol JoinJamPresentationLogic {
  func presentSomething(response: JoinJam.Something.Response)
}

class JoinJamPresenter: JoinJamPresentationLogic {
  weak var viewController: JoinJamDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: JoinJam.Something.Response) {
    let viewModel = JoinJam.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
    
}
