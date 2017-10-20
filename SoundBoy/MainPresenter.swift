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
  func presentUploadCompleted(response:Main.JamUpload.Response)
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  func presentProgress(response:Main.Progress.Response) {
    let progress = Int(response.progress * Float(100))
    let progString = "Uploading \(progress)%"
    viewController?.displayProgress(viewModel: Main.Progress.ViewModel(progress:progString))
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
  
  func presentUploadCompleted(response: Main.JamUpload.Response) {
    DispatchQueue.main.async {
      self.viewController?.displayUploadCompleted(viewModel: Main.JamUpload.ViewModel())
    }
    
  }
}
