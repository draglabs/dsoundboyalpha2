//
//  MainPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
  func presentProgress(progress:Float)
  func presentJamPin( jam:Jam)
  func presentJamActive()
  func presentCurrentRecordEnded()
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  func presentProgress(progress: Float) {
    viewController?.displayProgress(progress: progress)
  }
  func presentJamPin(jam: Jam) {
    if var pin = jam.pin {
      pin.insert(separator: "-", every: 3)
      let model = Main.Jam.ViewModel(pin: pin)
     self.viewController?.displayPin(viewModel: model)
    }
  }
  
  func presentJamActive() {
    
  }
  
  func presentCurrentRecordEnded() {
    viewController?.displayRecordEnded()
  }
}
