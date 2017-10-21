//
//  UserRegistration.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.


import Foundation

public enum UserRequest: RequestRepresentable {
    
    case register(facebookId:String, accessToken:String)
    case activity(userId:String)
    case details(userId:String,jamId:String)
  
    public var path: String {
        switch self {
        case .register(_:_):
            return "user/auth"
        case .activity(_):
          return "user/activity"
        case .details(_,let jamId):
          return "user/jam-details?jamId=\(jamId)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .register(_:_):
          return .post
        case .activity(_):
          return .get
        case .details(_,_):
          return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .register(let facebookId, let accessToken):
            return .body(["facebook_id":facebookId,"access_token":accessToken])
        case .activity(let userId):
          return .url(["user_id":userId])
        default:
          return .none
        
        }

    }
    
    public var headers: [String : Any]? {
        switch self {
        case .register(_: _):
          return["application/json":"Content-Type"]
        case .activity(let userId):
          return [userId:"user_id"]
        case .details(let userId,_):
          return [userId:"user_id"]
        }
      
    }
    
    public var dataType: DataType {
        switch self {
        default:
            return .JSON
        }
    }
    
}

class UserRegistrationOperation: OperationRepresentable {
    let facebookId :String
    let accessToken:String
    
    var responseError:((_ code:Int?, _ error:Error?)->())?

    var store:StoreRepresentable {
        return UserStore()
    }
    
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ created:Result<Any>) -> ()) {
        
        dispatcher.execute(request: request) { (response) in
            
            switch response {
            case .success(let data):
                self.store.from(data: data, response: result)
            case .error(_, _):
              result(Result.failed(message: "unable to login", error: nil))
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

