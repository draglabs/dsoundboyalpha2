//
//  StartJamRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol StartJamRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToMain()
}

protocol StartJamDataPassing
{
  var dataStore: StartJamDataStore? { get }
}

class StartJamRouter: NSObject, StartJamRoutingLogic, StartJamDataPassing
{
  weak var viewController: StartJamViewController?
  var dataStore: StartJamDataStore?
    
  // MARK: Routing
    
 func routeToMain() {
  let nav = viewController!.presentingViewController as! UINavigationController
  let main = nav.viewControllers.first as! MainViewController
    
 
//  var mainDS = main.router!.dataStore!
//  passDataToMain(source: dataStore!, destination: &mainDS)
   navigateToMain(source: viewController!, destination: main)
    }

 func navigateToMain(source:StartJamViewController, destination:MainViewController){
    source.dismiss(animated: true, completion: {})
    }
  
  // MARK: Passing data
  func passDataToMain(source: StartJamDataStore, destination: inout MainDataStore) {
     destination.success = source.success
   }
}
