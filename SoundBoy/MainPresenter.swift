//
//  MainPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol MainPresentationLogic {
  
  func presentFiles(response:Main.Jam.Response)
  func presentSettings(response:Main.Jam.Response)
  func presentProgress(progress:Float)
}

class MainPresenter: MainPresentationLogic {
  weak var viewController: MainDisplayLogic?
  
  func presentFiles(response: Main.Jam.Response) {
        
  }
  func presentSettings(response: Main.Jam.Response) {
    
  }
  func presentProgress(progress: Float) {
    
  }
}
