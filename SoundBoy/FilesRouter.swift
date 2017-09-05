//
//  FilesRouter.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

@objc protocol FilesRoutingLogic
{
    func routeToMain()
}

protocol FilesDataPassing {
    
    var dataStore: FilesDataStore? { get }
}

class FilesRouter: NSObject, FilesRoutingLogic, FilesDataPassing {
    weak var viewController: FilesViewController?
    var dataStore: FilesDataStore?
    
    func routeToMain() {
        let nav = viewController!.presentingViewController as! UINavigationController
        let main = nav.viewControllers.first as! MainViewController
        
        navigateToMain(source: viewController!, destination: main)
    }
    
    func navigateToMain(source:FilesViewController, destination:MainViewController){
        source.dismiss(animated: true, completion: {})
    }
}
