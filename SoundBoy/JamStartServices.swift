//
//  Jamming.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//
import Foundation
import CoreData
import CoreLocation
public enum JamRequest:RequestRepresentable {
    
  case start(userId:String, jamLocation:String,jamName:String, jamCoordinates:CLLocationCoordinate2D)
  
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
      //MARK:TODO Finish implementaion
    }
    func fromJSON(json: JSONDictionary, response: @escaping (Bool) -> ()) {
      guard let jam = json["jam"] as? JSONDictionary else {return}
      guard let id = jam["id"] as? String, let pin = jam["pin"] as? String,
      let startTime = jam["startTime"] as? String, let endTime = jam["endTime"] as? String
        else {return}
      let jamToSave = Jam()
      jamToSave.id = id
      jamToSave.pin = pin
      jamToSave.startTime = startTime
      jamToSave.endTime = endTime
      
      coreDataStore.save(completion: response)
    }
  
}

class StartJamOperation: OperationRepresentable {
  let userId:String
  let jamCoordinates:CLLocationCoordinate2D
  let name:String
  let location:String
  let userFether = UserFether()

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
