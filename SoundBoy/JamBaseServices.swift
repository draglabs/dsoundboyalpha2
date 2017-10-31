//
//  JamBaseServices.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreLocation

public enum JamResponseError {
  case jamActive(message:String)
  case invalidPin(message:String)
  
}
/// JamRequst representable
///- case : start
///- case : join
///- case : exit
///- case : collaborator
///- case : update
public enum JamRequest:RequestRepresentable {
  func parseUpdates(updates:[String:String?]) ->JSONDictionary? {
    var upds = [String:String]()
    if let usrId = updates["jam"] {
      upds["jam_id"] = usrId
    }
    if let name = updates["name"] {
      upds["update_name"] = name
    }
    if let location = updates["location"] {
      upds["location"] = location
    }
    if let notes = updates["notes"] {
      upds["update_notes"] = notes
    }
    return upds
  }
  case start(userId:String, jamLocation:String,jamName:String, jamCoordinates:CLLocationCoordinate2D)
  
  case join(uniqueId:String,pin:String)
  
  case exit (uniqueId:String, jamId:String)
  
  case collaborator(uniqueId:String, jamId:String)
  
  case update (userId:String,updates:[String:String?])
  
  public var dataType: DataType {
    switch self {
    case .start:
      return .JSON
    default:
      return .JSON
    }
  }
  
  /// these are optional list of headers we can send alogn with the call
  public var headers: [String : Any]? {
    switch self {
    case .update(let userId,_):
      return["application/json":"Content-Type",userId:"user_id"]
    default:
      return["application/json":"Content-Type"]
    }
    
  }
  
  /// These are the params we need to send along with the call
  public var parameters: RequestParams {
    switch self {
    case .start(let userId,let jamLocation, let jamName, let jamCoordinates):
      return .body(["user_id":userId,"jam_location":jamLocation,"jam_name":jamName, "jam_lat":"\(jamCoordinates.latitude)", "jam_long":"\(jamCoordinates.longitude)"])
      
    case .join(let uniqueId, let pin):
      return .body(["user_id":uniqueId, "pin":pin])
      
    case .exit(let uniqueId, let jamId):
      
      return .body(["user_id":uniqueId, "jam_id":jamId])
    case .collaborator( let uniqueId, let jamId):
      
      return .body(["user_id":uniqueId, "jam_id":jamId])
    case .update(_, let updates):
      return .body(parseUpdates(updates: updates))
    }
    
  }
  
  
  public  var method: HTTPMethod {
    switch self {
    case .update:
      return .patch
    default:
      return .post
    }
  }
  /// relative to the path of the enpodint we want to call, (i.e`/user/authorize/`)
  public var path: String {
    switch self {
    case .start:
      return "jam/start"
    case .exit :
      return "jam/exit"
      
    case .collaborator:
      return "jam/collaborators"
    case .join:
      return "jam/join"
    case .update:
      return "jam/update"
    }
  }
}

//=============StartJamOperation============================

class StartJamOperation: OperationRepresentable {
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
    return JamRequest.start(userId: userId, jamLocation: location, jamName: name, jamCoordinates: jamCoordinates)
  }
  
}

//=============JoinJamOperation============================

class JoinJamOperation:OperationRepresentable {
  
  let userId:String
  let jamPin:String
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var  request :RequestRepresentable {
    return JamRequest.join(uniqueId: userId, pin: jamPin)
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

//=============ExitJamOperation============================

class ExitJamOperation: OperationRepresentable {
  let userId:String
  let jamId:String
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
    return JamRequest.exit(uniqueId: userId, jamId: jamId)
  }
  
  private func parseReponse(response:Response,result: @escaping (_ exited:Bool)->()) {
    switch response {
    case .success(_):
      result(true)
    case .error(_,_):
      result(false)
    }
  }
  
  init(userId:String, jamId:String) {
    self.userId = userId
    self.jamId = jamId
  }
}
class UpdateJamOperation: OperationRepresentable {
  let userId:String
  let updates:[String:String?]
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
    return JamRequest.update(userId: userId, updates: updates)
  }
  
  private func parseReponse(response:Response,result: @escaping (_ exited:Bool)->()) {
    switch response {
    case .success(_):
      result(true)
    case .error(_,_):
      result(false)
    }
  }
  
  init(userId:String,updates:[String:String?]) {
    self.userId = userId
    self.updates = updates
  }
}
