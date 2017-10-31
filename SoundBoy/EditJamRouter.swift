//
//  EditJamRouter.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

@objc protocol EditJamRoutingLogic
{
 func dismiss()
}

protocol EditJamDataPassing
{
  var dataStore: EditJamDataStore? { get }
}

class EditJamRouter: NSObject, EditJamRoutingLogic, EditJamDataPassing
{
  weak var viewController: EditJamViewController?
  var dataStore: EditJamDataStore?
  
  // MARK: Routing
  func dismiss() {
    
  }
}
