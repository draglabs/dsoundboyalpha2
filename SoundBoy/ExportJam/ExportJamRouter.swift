//
//  ExportJamRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/26/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//

import UIKit

@objc protocol ExportJamRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  func dismiss()
}

protocol ExportJamDataPassing
{
  var dataStore: ExportJamDataStore? { get }
}

class ExportJamRouter: NSObject, ExportJamRoutingLogic, ExportJamDataPassing
{
  weak var viewController: ExportJamViewController?
  var dataStore: ExportJamDataStore?
  
  func dismiss() {
    print("called")
    viewController?.dismiss(animated: false, completion: nil)
  }
  
 
}
