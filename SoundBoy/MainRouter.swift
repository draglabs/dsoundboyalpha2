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
    func presentEditjam()
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
        //joinjamVC.modalPresentationStyle = .overCurrentContext
        
        viewController?.present(joinjamVC, animated: false, completion: {
            //some completion here
        })
    }
  
  func pushFiles() {
    let filesVC = UIStoryboard(name: "Files", bundle: nil).instantiateInitialViewController()
    
    viewController?.navigationController?.pushViewController(filesVC!, animated: true)
  }
  func pushSettings() {
    let nav = viewController?.navigationController as! dSoundNav
    let settings = SettingsViewController()
    nav.reversePush(controller: settings, animated: true)
    
  }
  
  func presentEditjam() {
    let editVC = UIStoryboard(name: "Edit", bundle: nil).instantiateInitialViewController()
    viewController?.present(editVC!, animated: true, completion: nil)
  }
}
