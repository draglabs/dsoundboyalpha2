//
//  FacebookAPI.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import FacebookLogin

final class FacebookAPI: NSObject {
  
  let networkDispatcher = DefaultDispatcher(enviroment: Env().dev)
  
  func loginUser(result:@escaping (_ registered:Result<Any>)->()) {
    LoginManager().logIn([.publicProfile, .email], viewController: nil) { (fbAPiResult) in
      switch fbAPiResult {
      case .success(_,  _, let token):
        
        let userRegistration = UserRegistrationOperation(facebookId: token.userId!, accessToken: token.authenticationToken)
        
        userRegistration.execute(in: self.networkDispatcher, result: { (registered) in
          DispatchQueue.main.async {
            result(registered)
          }
        })
        
      default:
        break
      }
    }
  }
}
