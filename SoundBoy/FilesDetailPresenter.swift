//
//  FilesDetailPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/20/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol FilesDetailPresentationLogic {
  func presentdetail(response: FilesDetail.Detail.Response)
}

class FilesDetailPresenter: FilesDetailPresentationLogic {
  weak var viewController: FilesDetailDisplayLogic?
  
  // MARK: Do something
  
  func presentdetail(response: FilesDetail.Detail.Response) {
    let viewModel = FilesDetail.Detail.ViewModel()
    viewController?.displaydetail(viewModel: viewModel)
  }
}
