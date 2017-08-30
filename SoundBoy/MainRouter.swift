//
//  MainRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol MainRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func presentStartJam()
}

protocol MainDataPassing
{
  var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing
{
  weak var viewController: MainViewController?
  var dataStore: MainDataStore?
  
  // MARK: Routing
  
    func presentStartJam() {
        let startjamVC = StartJamViewController()
        startjamVC.modalPresentationStyle = .overCurrentContext
        
        viewController?.present(startjamVC, animated: true, completion: {
            //some completion here
        })
    }
 
  // MARK: Navigation
  
  //func navigateToSomewhere(source: MainViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: MainDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
