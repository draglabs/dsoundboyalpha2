//
//  SharePresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 1/6/18.
//  Copyright (c) 2018 DragLabs. All rights reserved.
//

import UIKit

protocol SharePresentationLogic
{
  func presentSomething(response: Share.Something.Response)
}

class SharePresenter: SharePresentationLogic
{
  weak var viewController: ShareDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Share.Something.Response)
  {
    let viewModel = Share.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
