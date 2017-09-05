//
//  UserRegistration.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/31/17.
//  Copyright © 2017 DragLabs. All rights reserved.


import Foundation

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

class UserRegistrationOperation: OperationRepresentable {
    let facebookId :String
    let accessToken:String
    
    var responseError:((_ code:Int?, _ error:Error?)->())?
    
    var store:StoreRepresentable {
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

