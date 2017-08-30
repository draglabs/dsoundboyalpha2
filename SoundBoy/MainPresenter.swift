//
//  MainPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol MainPresentationLogic
{
  func presentSomething(response: Main.Jam.Response)
}

class MainPresenter: MainPresentationLogic
{
  weak var viewController: MainDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Main.Jam.Response)
  {
    let viewModel = Main.Jam.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
