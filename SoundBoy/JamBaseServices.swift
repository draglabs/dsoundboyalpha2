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
    if let usrId = updates["id"] {
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
  case new(userId:String, jamLocation:String,jamName:String, jamCoordinates:CLLocationCoordinate2D)
  
  case join(userId:String,pin:String)
  
  case exit (userId:String, jamId:String)
  
  case export(userId:String, jamId:String)
  
  case update (userId:String,updates:[String:String?])
  
  public var dataType: DataType {
    switch self {
    case .new:
      return .JSON
    default:
      return .JSON
    }
  }
  
  /// these are optional list of headers we can send alogn with the call
  public var headers: [String : Any]? {
    switch self {
    case .new(let userId,_,_,_):
      return["application/json":"Content-Type",userId:"user_id"]
     case .update(let userId,_):
      return["application/json":"Content-Type",userId:"user_id"]
    case .export(let userId, _):
      return ["application/json":"Content-Type",userId:"user_id"]
    default:
      return["application/json":"Content-Type"]
    }
    
  }
  
  /// These are the params we need to send along with the call
  public var parameters: RequestParams {
    switch self {
    case .new(let userId,let location, let name, let coordinates):
      return .body(["user_id":userId,"location":location,"name":name, "lat":coordinates.latitude, "lng":coordinates.longitude])
      
    case .join(let userId, let pin):
      return .body(["user_id":userId, "pin":pin])
      
    case .exit(let uniqueId, let jamId):
      return .body(["user_id":uniqueId, "jam_id":jamId])
      
    case .export( let userId, let jamId):
      return .body(["user_id":userId, "jam_id":jamId])
      
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
    case .new:
      return "jam/new"
    case .exit :
      return "jam/exit"
      
    case .export:
      return "jam/archive"
    case .join:
      return "jam/join"
    case .update:
      return "jam/update"
    }
  }
}

