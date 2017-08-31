//
//  JoinJamRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol JoinJamRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol JoinJamDataPassing
{
  var dataStore: JoinJamDataStore? { get }
}

class JoinJamRouter: NSObject, JoinJamRoutingLogic, JoinJamDataPassing
{
  weak var viewController: JoinJamViewController?
  var dataStore: JoinJamDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: JoinJamViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: JoinJamDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
