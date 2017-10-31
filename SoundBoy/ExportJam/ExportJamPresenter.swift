//
//  ExportJamPresenter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/26/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

protocol ExportJamPresentationLogic
{
  func presentExport(response: ExportJam.Export.Response)
}

class ExportJamPresenter: ExportJamPresentationLogic {
  weak var viewController: ExportJamDisplayLogic?
  
  // MARK: 
  
  func presentExport(response: ExportJam.Export.Response) {
    let viewModel = ExportJam.Export.ViewModel(message:response.message)

    DispatchQueue.main.async {
      self.viewController?.displayExporting(viewModel: viewModel)
    }
  }
}
