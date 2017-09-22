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

public enum JamRequest:RequestRepresentable {
  
  case start(userId:String, jamLocation:String,jamName:String, jamCoordinates:CLLocationCoordinate2D)
  
  case join(uniqueId:String,pin:String)
  
  case exit (uniqueId:String, jamId:String)
  
  case collaborator(uniqueId:String, jamId:String)
  
  
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
    
    return["application/json":"Content-Type"]
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
    }
    
  }
  
  
  public  var method: HTTPMethod {
    switch self {
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
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ started:Bool)->()) {
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .json(let json):
        self.store.fromJSON(json: json, response: result)
      case .data(let data):
        self.store.fromData(data: data, response: result)
      case .error(let status, let error):
        self.responseError?(status, error)
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
  
  func execute(in dispatcher:DispatcherRepresentable, result:@escaping (_ joined:Bool) -> ()) {
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .data(let data):
        self.store.fromData(data: data, response: result)
      case .json(let json):
        self.store.fromJSON(json: json, response: result)
      case .error(let statusCode, let error):
        self.responseError?(statusCode,error)
        
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
    case .json(let json):
      print(json)
      if let code = json["code"] as? NSNumber {
        if code == 200 {
          result(true)
        }else {
          result(false)
        }
      }
    default:
      break
    }
  }
  
  init(userId:String, jamId:String) {
    self.userId = userId
    self.jamId = jamId
  }
}
