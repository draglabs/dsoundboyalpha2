//
//  jamOperations.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreLocation

//=============StartJamOperation============================

struct StartJamOperation: OperationRepresentable {
  let userId:String
  let jamCoordinates:CLLocationCoordinate2D
  let name:String
  let location:String
  
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var store: StoreRepresentable {
    return JamStore()
  }
  
  init(userId:String,name:String, location:String,coordinates:CLLocationCoordinate2D) {
    self.userId = userId
    self.name = name
    self.location = location
    self.jamCoordinates = coordinates
    
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ started:Result<Any>)->()) {
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .success(let data):
        self.store.from(data: data, response: result)
      case .error(_,_):
        result(Result.failed(message: "Cant start jam", error: nil))
        break
      }
    }
  }
  var request: RequestRepresentable {
    return JamRequest.new(userId: userId, jamLocation: location, jamName: name, jamCoordinates: jamCoordinates)
  }
  
}

//=============JoinJamOperation============================

struct JoinJamOperation:OperationRepresentable {
  
  let userId:String
  let jamPin:String
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var  request :RequestRepresentable {
    return JamRequest.join(userId: userId, pin: jamPin)
  }
  var  store: StoreRepresentable {
    return JamStore()
  }
  
  func execute(in dispatcher:DispatcherRepresentable, result:@escaping (_ joined:Result<Any>) -> ()) {
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .success(let data):
        self.store.from(data: data, response: result)
      case .error(_,_):
        print("cant join Jam")
        result(Result.failed(message: "Cant joint Jam", error: nil))
        break
      }
    }
  }
  
  init(userId:String, jamPin:String) {
    self.userId = userId
    self.jamPin = jamPin
  }
}

//=============DetailsJamOperation============================

struct detailJamOperation: OperationRepresentable {
 
  let id:String
  var responseError:((_ code:Int?, _ error:Error?)->())?
  var store: StoreRepresentable {
    return JamStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ exited:Bool)->()) {
    dispatcher.execute(request: request) { (response) in
      self.parseReponse(response: response, result: result)
    }
  }
  
  var request: RequestRepresentable {
    return JamRequest.detail(id: id)
  }
  
  private func parseReponse(response:Response,result: @escaping (_ exited:Bool)->()) {
    switch response {
    case .success(_):
      result(true)
    case .error(_,_):
      result(false)
    }
  }
  
  init(jamId:String) {
    self.id = jamId
  }
}

//=============UpdateJamOperation============================

struct UpdateJamOperation: OperationRepresentable {
  let userId:String
  let updates:[String:String?]
  var responseError:((_ code:Int?, _ error:Error?)->())?
  var store: StoreRepresentable {
    return JamStore()
  }
  
   func execute(in dispatcher:DispatcherRepresentable, result:@escaping (_ joined:Result<Any>) -> ()) {
    dispatcher.execute(request: request) { (response) in
      self.parseReponse(response: response, result: result)
    }
  }
  
  var request: RequestRepresentable {
    return JamRequest.update(userId: userId, updates: updates)
  }
  
  private func parseReponse(response:Response,result:@escaping (_ joined:Result<Any>) -> ()){
    switch response {
    case .success(let data):
      store.from(data: data, response: result)
    case .error(_,_):
      result(Result.failed(message: nil, error: nil))
    }
  }
  
  init(userId:String,updates:[String:String?]) {
    self.userId = userId
    self.updates = updates
  }
}


//=============ExportJamOperation============================
struct ExportJamOperation: OperationRepresentable {
  let userId:String
  let jamId:String
  
  var store: StoreRepresentable {
    return JamStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ result:Result<Bool>)->()) {
    dispatcher.execute(request: request) { (response) in
      self.parseReponse(response: response, result: result)
    }
  }
  
  var request: RequestRepresentable {
    print(userId)
    return JamRequest.export(userId: userId, jamId: jamId)
  }
  
  private func parseReponse(response:Response,result: @escaping (_ result:Result<Bool>)->()) {
    switch response {
    case .success(_):
      result(Result.success(data: true))
    case .error(_,let error):
      print(error ?? "not error")
      result(Result.failed(message: "Unable to Export Jam", error: error))
    }
  }
  
  init(userId:String,jamId:String) {
    self.userId = userId
    self.jamId = jamId
  }
  

}
