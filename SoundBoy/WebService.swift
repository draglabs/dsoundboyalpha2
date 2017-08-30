//
//  WebService.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/13/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import FacebookLogin

/// Defines a JSON like dic
public typealias JSONDictionary = [String:Any]

// New Layer of network using SRP 

/// Defines the data we expect as response
/// - JSON: its a json 
/// - Data: its plain raw data
public enum DataType {
    case JSON
    case data
}

/// Define our http method to use when performing a request 
/// - post: POST HTTP method
/// - get:  GET HTTP  method
/// - put:  PUT HTTP  method
/// - delete: DELETE HTTP method
/// - patch: PATCH HTTP method


public enum HTTPMethod:String {
    case post   = "POST"
    case get    = "GET"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
  
}

public enum NetworkError :Error {
    case badInput
    case noData
    case unableToParse
    
}

/// Defines our parameters when sending a request
/// - body :  params sent using body
/// - url  :  params send as urlencoded
public enum RequestParams {
    case body(_ :JSONDictionary?)
    case url(_ :JSONDictionary?)
}


// this is the RequestRepresentable protocol to emplement as enum
public protocol RequestRepresentable {
    
    /// relative to the path of the enpodint we want to call, (i.e`/user/authorize/`)
    
    var path       : String        { get }
    
    /// This define the HTTP method we should use to perform the call
    /// we hace defined ir inside an String based enum called `HTTPMethod`
    var method     : HTTPMethod    {get }
    
    /// These are the params we need to send along with the call 
    var parameters : RequestParams { get }
    
    
    /// these are optional list of headers we can send alogn with the call 
    var headers    : [String:Any]? { get }
    
    /// The kind of data we expect as response 
    var dataType   : DataType      { get }
    
}

/// Define our response from performing a request
/// - json: json dictionaries
/// - data:  raw data
/// - error:  error

public enum Response {
    case json(_ :JSONDictionary)
    case data(_ :Data)
    case error(_:Int?, _:Error?)
    
    init(_ response:(r:HTTPURLResponse?, data:Data?, error:Error?), for request:RequestRepresentable) {
        
        // Draglabs custom reponse message
        if response.r?.statusCode == 400  {
            let jsonRes = try! JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions())
            self = .json(jsonRes as! JSONDictionary)
            return
        }
        
        guard response.r?.statusCode == 200, response.error == nil else {
            self = .error(response.r?.statusCode, response.error)
            return
        }
        
        
        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkError.noData)
            
            return
        }
        
        switch request.dataType {
        case .data:
            self = .data(data)
        case .JSON:
            
           let jsonRes = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
           
           
           guard  let json = jsonRes as? JSONDictionary else {
            self = .error(response.r?.statusCode, NetworkError.unableToParse)
            
            return
            }
           
            self = .json(json)
        }
    }
    
    
}

public struct Enviroment {
    
    /// Define the name of our enviroment
    public var name :String
    
    /// Define the base url of our enviroment
    public var host :String
    
    /// Defines the headers to send with the request
    /// along with any other headers from the url request
    /// useful if we want to add a custome header for each enviroment

    public var headers:[String:Any]? = nil
    
    /// Define our cache policy, default is: reloadIgnoringLocalCacheData
    public var cachePolicy:URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    public init (_ name:String, host:String) {
        self.name = name
        self.host = host
    }
    
}


public protocol DispatcherRepresentable {
    
    init(enviroment:Enviroment)
    
    func execute(request:RequestRepresentable,result:@escaping(_:Response)->())
}


public class NetworkDispatcher:DispatcherRepresentable {
    
    private var enviroment:Enviroment
    
    private var session:URLSession
    
    public required init(enviroment: Enviroment) {
        self.enviroment = enviroment
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30 * 60
        config.timeoutIntervalForResource = 30 * 60
        config.requestCachePolicy = enviroment.cachePolicy
        
        self.session = URLSession(configuration: config)
        
    }
    
    public func execute(request: RequestRepresentable, result:@escaping (_:Response)->()) {
       
           let rq = prepareURLRequest(for: request)
            session.dataTask(with: rq) { (data, urlResponse, error) in
                
                let res = Response((r: urlResponse as? HTTPURLResponse, data: data, error: error), for: request)
                
                result(res)
                
                }.resume()
        
        
    }
    
    private func prepareURLRequest(for request:RequestRepresentable)  -> URLRequest {
        let fullURL = "\(enviroment.host)/\(request.path)"
        
        
        var urlRequest = URLRequest(url: URL(string: fullURL)!)
        
        switch request.parameters {
            
        case .body(let param):
            
            if let bodyParams = param {
                let body = try! JSONSerialization.data(withJSONObject: bodyParams, options: [])
                urlRequest.httpBody = body
                } else {
            }
            
        default:
            break
        }
      
        enviroment.headers?.forEach({ (value, field) in
            urlRequest.addValue(value, forHTTPHeaderField: field as! String)
        })

        request.headers?.forEach({ (value, field) in
            urlRequest.addValue(value, forHTTPHeaderField: field as! String)
        })
        
        urlRequest.httpMethod = request.method.rawValue
       
        return urlRequest
    }
}

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

public protocol OperationRepresentable {
    
    associatedtype ResultType
    var request :RequestRepresentable { get }
    func execute(in dispatcher:DispatcherRepresentable, result:@escaping(_ result:ResultType)->())
}

 class UserRegistrationOperation: OperationRepresentable {
    
    let facebookId :String
    let accessToken:String
    
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ user:User?) -> ()) {
       
        dispatcher.execute(request: request) { (response) in
            
            switch response {
            case .data(let data):
                print(data)
                
            case .json(let json):
                result(User(json: json)!)
            case .error(let statusCode, let error):
                print(error ?? "none", statusCode ?? "")
                result(nil)
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


public enum JamRequest:RequestRepresentable {
    
    
    case start(uniqueId:String, jamLocation:String,jamName:String,jamLat:String,jamLong:String)
    
    case join(uniqueId:String,pin:String)
    
    case upload(uniqueId:String,jamId:String)
    
    case exit (uniqueId:String, jamId:String)
    
    case collaborator(uniqueId:String, jamId:String)
    
    /// The kind of data we expect as response,
    /// .JSON by default
    public var dataType: DataType {
        switch self {
        default:
            return .JSON
        }
    }

    /// these are optional list of headers we can send alogn with the call 
    public var headers: [String : Any]? {
        return nil
    }

    /// These are the params we need to send along with the call 
    public var parameters: RequestParams {
        switch self {
        case .start(let uniqueId, let jamLocation, let jamName, let jamLat, let jamLong):
        return .body(["unique_id":uniqueId,"jam_location":jamLocation,"jam_name":jamName,"jam_lat":jamLat,"jam_long":jamLong])
            
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
            return "jam/upload"
        case .collaborator:
            return "jam/collaborators"
        case .join:
            return "jam/join"
        }
    }
    
}

class StartJamOperation: OperationRepresentable {
    
    let jam:Jam
    
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ jam:Jam)->()) {
        dispatcher.execute(request: request) { (response) in
            switch response {
            case .json(let json):
                let jam = Jam(json)
                result(jam!)
            default:
                break
            }
        }
    }
    
    var request: RequestRepresentable {
        return JamRequest.start(uniqueId: jam.uniqueId, jamLocation: jam.jamLocation, jamName: jam.jamName, jamLat: jam.jamLat, jamLong: jam.jamLong)
    }
    
    init(jam:Jam) {
        self.jam = jam
    }
    
}


final class FacebookAPI {
    let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
    
    func loginUser(done:@escaping (_ done:Bool)->()) {
        LoginManager().logIn([.publicProfile], viewController: nil) { (fbAPiResult) in
            switch fbAPiResult {
            case .success(_,  _, let token):
                
                let userTask = UserRegistrationOperation(facebookId: token.userId!, accessToken: token.authenticationToken)
                
                userTask.execute(in: self.networkDispatcher, result: { (user) in
                    if let usr = user {
                        print(usr)
                        DispatchQueue.main.async {
                            done(true)
                        }
                    }
                })
                
                
            default:
                break
            }
        }
    }
    

    
}



















