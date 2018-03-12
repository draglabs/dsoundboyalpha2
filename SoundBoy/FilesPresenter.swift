//
//  FilesPresenter.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

protocol FilesPresentationLogic {
  func presentJams(response:Files.Response)
}


class FilesPresenter:FilesPresentationLogic {
    
  weak var viewController: FilesDisplayLogic?
    
  func presentJams(response: Files.Response) {
    DispatchQueue.main.async {
      self.viewController?.displayJams(viewModel: Files.ViewModel(Activity: response.Activity))
    }
  }
}

