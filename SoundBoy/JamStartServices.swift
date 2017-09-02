//
//  Jamming.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

public enum JamRequest:RequestRepresentable {
    
    case start(uniqueId:String, jamLocation:String,jamName:String,jamLat:String,jamLong:String)
    
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
        case .start(let userID, let jamLocation, let jamName, let jamLat, let jamLong):
            return .body(["user_id":userID,"jam_location":jamLocation,"jam_name":jamName,"jam_lat":jamLat,"jam_long":jamLong])
            
        case .join(let uniqueId, let pin):
            return .body(["unique_id":uniqueId, "pin":pin])
            
        case .exit(let uniqueId, let jamId):
            
            return .body(["unique_id":uniqueId, "jam_id":jamId])
        case .collaborator( let uniqueId, let jamId):
            
            return .body(["unique_id":uniqueId, "jam_id":jamId])
        case .upload(let uniqueId, let jamId):
            
            return .url(["unique_id":uniqueId, "jam_id":jamId])
        }
        
        
    }
    
    /// This define the HTTP method we should use to perform the call
    /// we hace defined ir inside an String based enum called `HTTPMethod`
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

class  JamStore: Store {
    let coreDataStore = CoreDataStore(entity: .user)
    var userFetchResult:((_ user:User?,_ error:Error?)->())?
    
    override func fromData(data: Data, response: @escaping (Bool) -> ()) {
        
    }
    override func fromJSON(json: JSONDictionary, response: @escaping (Bool) -> ()) {
        
    }
    
    func fetch(callback: @escaping (Jam?, Error?) -> ()) {
        
    }
    
    
}
class StartJamOperation: OperationRepresentable {
    
    let jam:Jam
    var responseError:((_ code:Int?, _ error:Error?)->())?
    
    var store: Store {
        return JamStore()
    }
    init(jam:Jam) {
        
        self.jam = jam
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
        
        return JamRequest.start(uniqueId: "", jamLocation: jam.location!, jamName: jam.name!, jamLat: jam.latitude!, jamLong: jam.longitude!)
    }
    
    
}
