//
//  SettingsRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol SettingsRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  func popBack()
}

protocol SettingsDataPassing {
  var dataStore: SettingsDataStore? { get }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing {
  weak var viewController: SettingsViewController?
  var dataStore: SettingsDataStore?
  func popBack() {
    let nav = viewController?.navigationController as! dSoundNav
    nav.reversePop(animated: true)
  }
}
