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

/// Defines the dta we expect as response
/// - JSON: its a json 
/// - Data: its plain raw data
public enum DataType {
    case JSON
    case data
}

/// Define our http method to use when performing a request 

public enum HTTPMethod:String {
    case post   = "POST"
    case get    = "GET"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
  
}

/// Defines our parameters when sending a request
/// - body : params sent using body
/// - url : params send as urlencoded
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


public enum Response {
    case json(_ :JSONDictionary)
    case data(_ :Data)
    case error(_:Int?, _:Error?)
    
    init(_ response:(r:HTTPURLResponse?, data:Data?, error:Error?), for request:RequestRepresentable) {
        
        
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
    
    /// Define the headers to send along with the request
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


public enum NetworkError :Error {
    case badInput
    case noData
    case unableToParse
    
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
    
    var facebookId :String
    var accessToken:String
    
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
    
    /// The kind of data we expect as response 
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
    
    }
    
    
}

class JamTaskOperation: OperationRepresentable {
    
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ jam:Jam)->()) {
        
    }
    var request: RequestRepresentable {
        return JamRequest
    }
}


enum Enpoint:String {
    case auth       = "https://api.draglabs.com/v1.01/user/auth"
    case startJam   = "https://api.draglabs.com/v1.01/jam/start"
    case exitJam    = "https://api.draglabs.com/v1.01/jam/exit"
    case joinJam    = "https://api.draglabs.com/v1.01/jam/join"
    case soloUpload = "https://api.draglabs.com/v1.01/soloupload/id/"
    case jamUpload  = "https://api.draglabs.com/v1.01/jam/upload/"
}


extension Enpoint {
    
    var string:String {
        switch self {
        case .auth:
            return String(self.rawValue)
       case .startJam:
            return String(self.rawValue)
        case .exitJam:
            return String(self.rawValue)
        case .joinJam:
            return String(self.rawValue)
        case .soloUpload:
            return String(self.rawValue)
        case .jamUpload:
            return String(self.rawValue)
        }
    }
}





final class Fetcher {
    
    let networkDispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
    
    
    func facebookApi(done:@escaping (_ done:Bool)->()) {
        LoginManager().logIn([.publicProfile], viewController: nil) { (fbAPiResult) in
            switch fbAPiResult {
            case .success(_,  _, let token):
                
                let userTask = UserRegistrationOperation(facebookId: token.userId!, accessToken: token.authenticationToken)
                
                userTask.execute(in: self.networkDispatcher, result: { (user) in
                    print(user ?? "not user")
                })
                
                
            default:
                break
            }
        }
    }
    
    

    let locationManager = LocationMgr()
  private   func registerUser(params:[String],completion:@escaping (_ userId:String)->()) {
    
    
       let url = URL(string: Enpoint.auth.string)!
    
        let bodyParams:[String:Any] = ["facebook_id":params[0], "access_token":params[1]]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        let body = try! JSONSerialization.data(withJSONObject: bodyParams, options: [])
    
        request.httpBody = body
    
        URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            
            guard let data = responseData else { return }
            
            do  {
              let json  = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dic = json as? JSONDictionary else {return }
                guard let user = dic["user"] else{return}
                if let id = user as? [String:String] {
                    
                    completion(id["id"]!)
                }
                
                
            }
            catch let err  {
                // hadle error
                print(err)
            }
            
            
            
        }.resume()
    }

    
    private func startAJam(params:RequestParams, completion:@escaping(_ jamID:String?,_ error:Error?)->()) {
        
//        let url = URL(string:Enpoint.startJam.string)!
//        guard let id = UserDefaults.standard.object(forKey: "user_id") as? String else  {return }
//        var bodyParam = params
//        bodyParam["user_id"] = id
//        locationManager.requestLocation()
//        guard let location = locationManager.lastLocation else {return}
//        
//        
//        
//        
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = try! JSONSerialization.data(withJSONObject: bodyParam, options: [])
//        request.httpBody = body
//        
//        
//        
//        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
//            
//        }.resume()
        
        
    }
    
    private func endJam(userId:String, completion:@escaping(_ done:Bool)->()) {
      
        
    }
    
 
    
    
}



















