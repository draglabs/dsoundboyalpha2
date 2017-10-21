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
    passDataTo(source: dataStore!, destination: &destinationDS)
   
    navigateTo(source: viewController!, destination: detailVC)
    
  }
    
  func navigateTo(source:FilesViewController, destination:UIViewController){
        source.navigationController?.pushViewController(destination, animated: true)
    }
  func passDataTo(source: FilesDataStore, destination: inout FilesDetailDataStore) {
      destination.jamId = source.activity!.jams[row].id
    
  }
 
}
