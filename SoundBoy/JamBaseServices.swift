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
