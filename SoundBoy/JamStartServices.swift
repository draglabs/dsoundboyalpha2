//
//  Jamming.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//
import Foundation
import CoreData
public enum JamRequest:RequestRepresentable {
    
  //case start(userId:String, jamLocation:String,jamName:String,jamLat:String,jamLong:String)
  case start(jamName:String,jamLocation:String)
  
    case join(uniqueId:String,pin:String)
    
    case upload(uniqueId:String,jamId:String)
    
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
    public var headers: [String : Any]? { return nil }
    
    /// These are the params we need to send along with the call
    public var parameters: RequestParams {
        switch self {
        case .start(let jamLocation, let jamName):
            return .body(["jam_location":jamLocation,"jam_name":jamName])
            
        case .join(let uniqueId, let pin):
            return .body(["user_id":uniqueId, "pin":pin])
            
        case .exit(let uniqueId, let jamId):
            
            return .body(["user_id":uniqueId, "jam_id":jamId])
        case .collaborator( let uniqueId, let jamId):
            
            return .body(["user_id":uniqueId, "jam_id":jamId])
        case .upload(let uniqueId, let jamId):
            
            return .url(["user_id":uniqueId, "jam_id":jamId])
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
        case .upload:
            return "jam/upload/uniqueid"
        case .collaborator:
            return "jam/collaborators"
        case .join:
            return "jam/join"
        }
    }
}

class  JamStore: StoreRepresentable {
    let coreDataStore = CoreDataStore(entity: .user)
    var userFetchResult:((_ user:User?,_ error:Error?)->())?
    
    func fromData(data: Data, response: @escaping (Bool) -> ()) {
        
    }
    func fromJSON(json: JSONDictionary, response: @escaping (Bool) -> ()) {
        
    }
  
}

class StartJamOperation: OperationRepresentable {
  
  let name:String
  let location:String
  let userFether = UserFether()

  var responseError:((_ code:Int?, _ error:Error?)->())?
    
  var store: StoreRepresentable {
    return JamStore()
    }
  
  init(name:String, location:String) {
    
    self.name = name
    self.location = location
    
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
        
        return JamRequest.start(jamName: name, jamLocation: location)
    }
  
}
