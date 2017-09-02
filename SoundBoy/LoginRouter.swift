//
//  LoginRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

@objc protocol LoginRoutingLogic
{
    func routeToMainController(source:LoginViewController)
    
}

protocol LoginDataPassing
{
  var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing
{
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?

  // MARK: Routing
    
    func routeToMainController(source: LoginViewController) {
        let mainController = MainViewController()
        source.navigationController?.setViewControllers([mainController], animated: true)
    }
    
}
