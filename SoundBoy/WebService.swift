//
//  WebService.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/13/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation

// extension to append string to Data
extension Data {
    mutating func append(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
    
public typealias JSONDictionary = [String:Any]

public enum DataType {
    case JSON
    case data
}

public enum HTTPMethod:String {
    case post   = "POST"
    case get    = "GET"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
  
}

public enum RequestParams {
    case body(_ :JSONDictionary?)
    case url(_ :JSONDictionary?)
}



public enum NetworkError :Error {
    case badInput
    case noData
    case unableToParse
    
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

/* =====================MultipartRepresentable====================*/
public protocol MultipartRepresentable {
    var body:Data {get}
    func createBody(boundary:String) ->Data
    
}
/* =====================RequestRepresentable====================*/
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
            guard let js = jsonRes as? JSONDictionary else {self = .error(response.r?.statusCode, NetworkError.unableToParse); return }
            self = .json(js)
        }
        
    }
}

/* =====================OperationRepresentable====================*/
public protocol OperationRepresentable {
    
    associatedtype ResultType
    
    var  request :RequestRepresentable { get }
    var  store: StoreRepresentable {get } //
    func execute(in dispatcher:DispatcherRepresentable, result:@escaping(_ result:ResultType)->())
}


/* =====================DispatcherRepresentable====================*/
public protocol DispatcherRepresentable {
    
    init(enviroment:Enviroment)
    
    func execute(request:RequestRepresentable,result:@escaping(_:Response)->())
}



/* =====================NetworkDispatcher====================*/

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
                } else {}
            
        case .url(let params):
            var url = urlRequest.url!.baseURL!.absoluteString
            params?.forEach{url.append("/\($0)/\($1)")}
            urlRequest.url = URL(string: url)
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





















