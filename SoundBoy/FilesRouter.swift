//
//  FilesRouter.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

@objc protocol FilesRoutingLogic {
  func routeToDetail(index:Int)
  func routeToExport(index:Int)
  func routeToEdit(index:Int)
}

protocol FilesDataPassing {
    
  var dataStore: FilesDataStore? { get }
}

class FilesRouter: NSObject, FilesRoutingLogic, FilesDataPassing {
    weak var viewController: FilesViewController?
    var dataStore: FilesDataStore?
    var row:Int!
  
  func routeToDetail(index:Int) {
    self.row = index
    let detailVC = FilesDetailViewController()
    var destinationDS = detailVC.router!.dataStore!
    passDataToDetails(source: dataStore!, destination: &destinationDS)
    navigateTo(source: viewController!, destination: detailVC)
    
  }
  // MARK: Routing
  func routeToExport(index:Int) {
    self.row = index
    let exportVC = ExportJamViewController()
    exportVC.modalPresentationStyle = .overCurrentContext
    var destinationDS = exportVC.router!.dataStore!
    passDataToExport(source: dataStore!, destination: &destinationDS)
    viewController?.present(exportVC, animated: false, completion: nil)
  }
  func routeToEdit(index:Int) {
    self.row = index
    let edit = UIStoryboard(name: "Files", bundle: nil).instantiateViewController(withIdentifier: "Edit") as! EditJamViewController
    var ds = edit.router!.dataStore!
    passDataToEdit(source: dataStore!, destination: &ds)
    viewController?.present(edit, animated: true, completion: nil)
  }
  
  func navigateTo(source:FilesViewController, destination:UIViewController){
        source.navigationController?.pushViewController(destination, animated: true)
    }
  func passDataToDetails(source: FilesDataStore, destination: inout FilesDetailDataStore) {
      destination.jamId = source.activity![row].id
  }
  
  func passDataToExport(source:FilesDataStore, destination: inout ExportJamDataStore) {
    destination.jamId = source.activity![row].id
  }
  
  func passDataToEdit(source:FilesDataStore, destination: inout EditJamDataStore) {
    destination.jamId = source.activity![row].id
  }
}
