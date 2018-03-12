//
//  FilesDetailRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/20/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol FilesDetailRoutingLogic {
  func routeToExport()
}

protocol FilesDetailDataPassing {
  var dataStore: FilesDetailDataStore? { get }
}

class FilesDetailRouter: NSObject, FilesDetailRoutingLogic, FilesDetailDataPassing {
  weak var viewController: FilesDetailViewController?
  var dataStore: FilesDetailDataStore?
  
  // MARK: Routing
  func routeToExport() {
    let exportVC = ExportJamViewController()
    viewController?.present(exportVC, animated: true, completion: nil)
  }

}
