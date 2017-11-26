//
//  App.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit
import CoreData


private class AppFetcher: FetcherRepresentable {
    
     var coreDataStore: CoreDataStore {
        return CoreDataStore(entity: .user)
    }
    
    func fetch(callback: @escaping (_ result:User?, _ error:Error?) -> ()) {
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        coreDataStore.viewContext.perform {
            do {
                let r =  try fetchRequest.execute()
                print("number of current users ",r.count)
                if  let t = r.first {
                    callback(t, nil)
                }else {
                    callback(nil, nil)
                }
            }catch {
                callback(nil,error)
                
            }
            
        }
        
    }
  func delete(callback: @escaping (_ deleted:Bool) -> ()) {
    
  }
}

class App: NSObject {
  
   let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
   let oboadingVC = LoginViewController()
   var navController = dSoundNav()
    
   fileprivate let userFetcher = AppFetcher()
    
     init(window:UIWindow) {
        
        super.init()
        window.rootViewController = navController
        
        userFetcher.fetch {[unowned self] (user, error) in
            if user != nil {
             
                  Customizer.main(nav: self.navController)
              self.navController.setViewControllers([self.mainVC!], animated: true)
               
            }else {
                self.navController.setViewControllers([self.oboadingVC], animated: true)
              Customizer.login(nav: self.navController)
            }
        }
      
    }
}








