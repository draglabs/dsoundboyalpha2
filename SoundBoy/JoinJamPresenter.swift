//
//  JoinJamPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol JoinJamPresentationLogic {
  func presentCommons(response: JoinJam.Commons.Response)
  func presentDidJoinJam(response: JoinJam.Join.Response)
}

class JoinJamPresenter: JoinJamPresentationLogic {
  weak var viewController: JoinJamDisplayLogic?
  
  // MARK: Commons
  
  func presentCommons(response: JoinJam.Commons.Response) {
    let viewModel = JoinJam.Commons.ViewModel()
    viewController?.displayCommons(viewModel: viewModel)
  }
  func presentDidJoinJam(response: JoinJam.Join.Response) {
    let viewModel = JoinJam.Join.ViewModel(didJoin: response.didJoin)
    viewController?.displayDidJoin(viewModel: viewModel)
  }
    
}
