//
//  FilesPresenter.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

protocol FilesPresentationLogic {
  func presentActivitity()
}


class FilesPresenter:FilesPresentationLogic {
    
    weak var viewController: FilesDisplayLogic?
    
  func presentActivitity() {
    
  }
}

