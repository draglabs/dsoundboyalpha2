//
//  ExitJam.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/10/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
class ExitJam: OperationRepresentable {
  let userId:String
  let jamId:String
  var responseError:((_ code:Int?, _ error:Error?)->())?
  var store: StoreRepresentable {
    return JamStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ exited:Bool)->()) {
    dispatcher.execute(request: request) { (response) in
      switch response {
      case .data(let data):
        self.store.fromData(data: data, response: result)
      case .json(let json):
        self.store.fromJSON(json: json, response: result)
      case .error(let statusCode, let error):
        result(false)
        self.responseError?(statusCode,error)
      }
    }
  }
  
  var request: RequestRepresentable {
    return JamRequest.exit(uniqueId: userId, jamId: jamId)
  }
  
  init(userId:String, jamId:String) {
    self.userId = userId
    self.jamId = jamId
  }
}
