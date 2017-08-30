//
//  App.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class App: NSObject {
    
    
   let mainVC = MainViewController()
   let oboadingVC = LoginViewController()
   var navController = UINavigationController()
    
     init(window:UIWindow) {
        
        super.init()
        window.rootViewController = navController
        
        if isAuth() {
            navController.setViewControllers([mainVC], animated: true)
            Customizer.nav(nav: navController)
        }else {
            navController.setViewControllers([oboadingVC], animated: true)
            Customizer.nav(nav: navController)
        }
        
    }

    
    func isAuth() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: "user_id") as? String else{return false }
        return true
    }
    
   
}



//MARK: MainViewContoller Delegate Conformance


//MARK: OnboardingViewController Delegate Conformace
//extension App:OnboardingVCDelegate {
//    func didLogin() {
//        DispatchQueue.main.async {
//          self.navController.setViewControllers([self.mainVC], animated: true)
//        }
//        
//    }
//}



