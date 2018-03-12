//
//  ExportJamInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/26/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol ExportJamBusinessLogic {
  func export(request: ExportJam.Export.Request)
}

protocol ExportJamDataStore {
  var jamId: String { get set }
}

class ExportJamInteractor: ExportJamBusinessLogic, ExportJamDataStore {
  var presenter: ExportJamPresentationLogic?
  var worker: ExportJamWorker?
  let jamWorker = JamWorker()
  var jamId: String = ""
  
  // MARK: Export
  
  func export(request: ExportJam.Export.Request) {
    jamWorker.export(jamId: jamId) { (result) in
      switch result {
      case .failed(let msg, _):
        self.presenter?.presentExport(response: ExportJam.Export.Response(message:msg!))
      case .success(_):
        self.presenter?.presentExport(response: ExportJam.Export.Response(message:"Jam Exported!"))
      }
    }
  }
}
