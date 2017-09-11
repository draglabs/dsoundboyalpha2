//
//  SettingsPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol SettingsPresentationLogic
{
  func presentSomething(response: Settings.Something.Response)
}

class SettingsPresenter: SettingsPresentationLogic
{
  weak var viewController: SettingsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Settings.Something.Response)
  {
    let viewModel = Settings.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
