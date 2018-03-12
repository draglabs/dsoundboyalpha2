//
//  ShareRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 1/6/18.
//  Copyright (c) 2018 DragLabs. All rights reserved.
//

import UIKit

@objc protocol ShareRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ShareDataPassing
{
  var dataStore: ShareDataStore? { get }
}

class ShareRouter: NSObject, ShareRoutingLogic, ShareDataPassing
{
  weak var viewController: ShareViewController?
  var dataStore: ShareDataStore?
  
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
  
  //func navigateToSomewhere(source: ShareViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ShareDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
