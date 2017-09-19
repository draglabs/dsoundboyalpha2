//
//  JoinJamService.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation


class JoinJamOperaion:OperationRepresentable {
  
  let userId:String
  let jamPin:String
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var  request :RequestRepresentable {
  return JamRequest.join(uniqueId: userId, pin: jamPin)
  }
  var  store: StoreRepresentable {
    return JamStore()
  }
  
  func execute(in dispatcher:DispatcherRepresentable, result:@escaping (_ created:Bool) -> ()) {
    dispatcher.execute(request: request) { (response) in
      switch response {
      case .data(let data):
        self.store.fromData(data: data, response: result)
      case .json(let json):
        self.store.fromJSON(json: json, response: result)
      case .error(let statusCode, let error):
        self.responseError?(statusCode,error)
        result(false)
      }
    }
  }
  
  
  init(userId:String, jamPin:String) {
    self.userId = userId
    self.jamPin = jamPin
  }
}
