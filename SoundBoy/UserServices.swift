//
//  UserRegistration.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.


import Foundation
import CoreData
import FacebookLogin



public enum UserRequest: RequestRepresentable {
    
    case register(facebookId:String, accessToken:String)
    public var path: String {
        switch self {
        case .register(_:_):
            return "user/auth"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .register(_:_):
            return .post
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .register(let facebookId, let accessToken):
            return .body(["facebook_id":facebookId,"access_token":accessToken])
        }

    }
    
    public var headers: [String : Any]? {
        switch self {
        case .register(_: _):
            return["application/json":"Content-Type"]
        }
    }
    
    public var dataType: DataType {
        switch self {
        case .register(_, _: _):
            return .JSON
        }
    }
    
}


class UserStore: Store {
    let coreDataStore = CoreDataStore(entity: .user)
    var userFetchResult:((_ user:User?,_ error:Error?)->())?
    
    
    override func fromData(data: Data, response: @escaping(_ uploaded:Bool)->()) {
        //MARK:TODO finish implementation
    }
    
    override func fromJSON(json: JSONDictionary, response: @escaping(_ uploaded:Bool)->()) {
        
        let context = coreDataStore.viewContext
        let user = User(context: context)
        user.userId = json["id"] as? String
        response(true)
        coreDataStore.save(completion: response)
        
    }
    
     func fetch(callback: @escaping (_ result:User?, _ error:Error?) -> ()) {
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        coreDataStore.viewContext.perform {
            do {
                let userResult =  try fetchRequest.execute()
                if  let user = userResult.first {
                    callback(user, nil)
                    self.userFetchResult?(user,nil)
                }
            }catch {
                callback(nil,error)
                self.userFetchResult?(nil,error)
            }
            
        }
        
    }
    
   
}


class UserRegistrationOperation: OperationRepresentable {
    let facebookId :String
    let accessToken:String
    
    var responseError:((_ code:Int?, _ error:Error?)->())?
    
    var store:UserStore {
        return UserStore()
    }
    
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ created:Bool) -> ()) {
        
        dispatcher.execute(request: request) { (response) in
            
            switch response {
            case .data(let data):
                self.store.fromData(data: data, response: result)
            case .json(let json):
                self.store.fromJSON(json: json, response: result)
            case .error(let statusCode, let error):
                self.responseError?(statusCode, error)
            }
        }
    }
    
    
    init(facebookId:String,accessToken:String) {
        self.facebookId = facebookId
        self.accessToken = accessToken
    }
    
    var request: RequestRepresentable {
        return UserRequest.register(facebookId: facebookId, accessToken: accessToken)
    }

}


// FACEBOOK API
final class FacebookAPI {
    let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
    
    func loginUser(result:@escaping (_ registered:Bool)->()) {
        LoginManager().logIn([.publicProfile], viewController: nil) { (fbAPiResult) in
            switch fbAPiResult {
            case .success(_,  _, let token):
                
                let userRegistration = UserRegistrationOperation(facebookId: token.userId!, accessToken: token.authenticationToken)
                
                userRegistration.execute(in: self.networkDispatcher, result: { (registered) in
                    DispatchQueue.main.async {
                        result(registered)
                    }
                })
                
            default:
                break
            }
        }
    }
    
}
