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
    func presentJoinJam()
    func pushFiles()
    func pushSettings()
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
  
    func presentJoinJam() {
        let joinjamVC = JoinJamViewController()
        joinjamVC.modalPresentationStyle = .overCurrentContext
        
        viewController?.present(joinjamVC, animated: true, completion: {
            //some completion here
        })
    }
  
  func pushFiles() {
    let filesVC = FilesViewController()
    viewController?.navigationController?.pushViewController(filesVC, animated: true)
  }
  func pushSettings() {
    let nav = viewController?.navigationController as! dSoundNav
    let settings = SettingsViewController()
    nav.reversePush(controller: settings, animated: true)
    
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
