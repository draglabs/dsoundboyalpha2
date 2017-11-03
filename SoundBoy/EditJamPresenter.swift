//
//  EditJamPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol EditJamPresentationLogic {
  func presentCurrentJam(response: EditJam.CurrentJam.Response)
  func presentUpdated(response:EditJam.Update.Response)
}

class EditJamPresenter: EditJamPresentationLogic {
  weak var viewController: EditJamDisplayLogic?
  
  // MARK: Do
  
  func presentCurrentJam(response: EditJam.CurrentJam.Response) {
    let name =    response.name!
    let location = response.location
    let notes =   response.notes
    let viewModel = EditJam.CurrentJam.ViewModel(name: name, location: location, notes: notes)
    viewController?.displayCurrentJam(viewModel: viewModel)
    
   }
  func presentUpdated(response:EditJam.Update.Response){
    
  }
}
