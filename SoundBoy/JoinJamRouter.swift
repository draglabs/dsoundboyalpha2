//
//  JoinJamRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol JoinJamRoutingLogic {
 
  func dismiss()
}

protocol JoinJamDataPassing {
  var dataStore: JoinJamDataStore? { get }
}

class JoinJamRouter: NSObject, JoinJamRoutingLogic, JoinJamDataPassing {
  weak var viewController: JoinJamViewController?
  var dataStore: JoinJamDataStore?
  
  // MARK: Routing
  
  
  func dismiss() {
    //let main = MainViewController()
    if let main = viewController?.presentingViewController?.childViewControllers.first as? MainViewController{
      var mainDataStore = main.router!.dataStore
      passDataToMain(source: dataStore!, destination: &mainDataStore!)
      viewController?.dismiss(animated: false, completion: nil)
    }
    
  }
  
  func passDataToMain(source: JoinJamDataStore, destination: inout MainDataStore) {

    destination.didJoin = source.didJoin
  }
}
