//
//  dSoundNav.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class dSoundNav: UINavigationController {
  var controllersCount:Int {
    return reversedPushControllers.count + viewControllers.count
  }
  var reversedPushControllers:[UIViewController] = []
  
  func reversePush(controller:UIViewController, animated:Bool) {
    var controllers = self.viewControllers
    reversedPushControllers.append(controllers.last!)
    controllers.insert(controller, at: controllers.count - 1)
    setViewControllers(controllers, animated: false)
    popViewController(animated: animated)
  }
  
  func reversePop(animated:Bool) {
    var controllers = self.viewControllers
    controllers.removeLast()
    controllers.append(reversedPushControllers.last!)
    reversedPushControllers.removeLast()
    setViewControllers(controllers, animated: animated)
    
  }
  
  func setRoot(controller:UIViewController) {
    if controllersCount > 1 {
      if reversedPushControllers.count != 0 {
        reversedPushControllers[0] = controller
        popToRoot(animated: true)
      }else {
        var viewControllers = self.viewControllers
        viewControllers[0] = controller
        setViewControllers(viewControllers, animated: false)
        popToRoot(animated: true)
      }
      
      
    }else if topViewController != controller {
      UIView.animate(withDuration: 0.4, delay: 0, options: [.allowAnimatedContent, .transitionCrossDissolve], animations: {
        UIView.setAnimationsEnabled(false)
      }, completion: nil)
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.isEnabled = false
  }
  
  @discardableResult func popToRoot(animated:Bool) ->[UIViewController]?{
    
    if reversedPushControllers.count != 0 {
      setViewControllers([reversedPushControllers[0]], animated: animated)
    }else {
      return super.popToRootViewController(animated: animated)
    }
    reversedPushControllers.removeLast()
    return nil
  }
  
}
