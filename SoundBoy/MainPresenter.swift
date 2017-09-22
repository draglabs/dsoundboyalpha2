//
//  MainPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentProgress(response:Main.Progress.Response)
  func presentJamPin(response:Main.Jam.Response)
  func presentJamActive(response:Main.JamActive.Response)
  
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  func presentProgress(response:Main.Progress.Response) {
    viewController?.displayProgress(viewModel: Main.Progress.ViewModel(progress: response.progress))
  }
  func presentJamPin(response:Main.Jam.Response) {
      var pin = response.pin
      pin.insert(separator: "-", every: 3)
      let model = Main.Jam.ViewModel(pin: pin)
     self.viewController?.displayPin(viewModel: model)
    
  }
  
  func presentJamActive(response:Main.JamActive.Response) {
    viewController?.displayIsJamActive(viewModel: Main.JamActive.ViewModel(isActive: response.isActive))
  }
}
