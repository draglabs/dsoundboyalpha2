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
  func presentTexfields(response: StartJam.Textfields.Response)
  func presentSuccess(response: StartJam.Success.Response)
  func presentJam(response: StartJam.Submit.Response)
}

class StartJamPresenter: StartJamPresentationLogic
{
  weak var viewController: StartJamDisplayLogic?
  
  // MARK: Presinting logic
  
  func presentTexfields(response: StartJam.Textfields.Response) {
    let viewModel = StartJam.Textfields.ViewModel()
    viewController?.displayTextfields(viewModel: viewModel)
  }
  
 func presentJam(response: StartJam.Submit.Response) {
        
    }
 func presentSuccess(response: StartJam.Success.Response) {
     
    }
    
}
