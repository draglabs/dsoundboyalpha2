//
//  APIBase.swift
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

/// The Type of Data we expect
public enum DataType {
  case JSON
  case data
}

/// HTTPMethod of the request
public enum HTTPMethod:String {
  case post   = "POST"
  case get    = "GET"
  case put    = "PUT"
  case delete = "DELETE"
  case patch  = "PATCH"
  
}

/// Params send along with the request
public enum RequestParams {
  case body(_ :JSONDictionary?)
  case url(_ :JSONDictionary?)
}


/// Error from network call
public enum NetworkError :Error {
  case badInput
  case noData
  case unableToParse
  
}

public enum ParsingOptions {
  case json
  case array
  case dictionary
  case raw
}
/// Parses raw Data to json
///needs to be extended to support
/// arrays more.
public struct Parser {
  
  func parse(to parsingOptions:ParsingOptions,from data:Data?) -> JSONDictionary? {
    
    guard let raw = data else { return nil }
    let jsonAny = try? JSONSerialization.jsonObject(with: raw, options: JSONSerialization.ReadingOptions())
    guard let json = jsonAny as? JSONDictionary else { return nil }
    return json
  }
  
  func parse(to parsingOptions:ParsingOptions, from json:JSONDictionary) ->Data? {
    return try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
  }
  
  private func parseToArray(from data:Data) {
    fatalError("`func parseToArray(from data:Data)` not implemented")
  }
  
  private func parseToDictionary(from data:Data) {
    fatalError("`func parseToDictionary(from data:Data)` not implemented")
  }

}

/// The enviroment we're working on
/// example: `Development`

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

/* =====================RequestRepresentable====================*/
public protocol RequestRepresentable {
  
  /// relative to the path of the enpodint we want to call, (i.e`/user/authorize`)
  
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

/// Response enum
/// Represent a reponse from the server
public enum Response {

  
  case json(_ :JSONDictionary)
  case data(_ :Data)
  case error(_:Int?, _:Error?)
  
  init(_ response:(r:HTTPURLResponse?, data:Data?, error:Error?), for request:RequestRepresentable) {
    
    // Draglabs custom reponse message
    if response.r!.statusCode >= 400 {
      let parser = Parser()
      let parsedjson = parser.parse(to: .dictionary, from: response.data)
      self = .json(parsedjson!)

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
      let parser = Parser()
      let parsedjson = parser.parse(to: .dictionary, from: data)
      if parsedjson != nil {
        self = .json(parsedjson!)
        return
      }else {
        self = .error(response.r?.statusCode, NetworkError.unableToParse)
        return
      }
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

/// The Default network dispatcher
public class DefaultDispatcher:DispatcherRepresentable {
  
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
//      print(data)
//      print(urlResponse)
//      print(error)
      }.resume()
  }
  
  private func prepareURLRequest(for request:RequestRepresentable)  -> URLRequest {
    let fullURL = "\(enviroment.host)/\(request.path)"
    var urlRequest = URLRequest(url: URL(string: fullURL)!)
    
    switch request.parameters {
      
    case .body(let param):
      let parser = Parser()
      if let bodyParams = param {
        let body = parser.parse(to: .raw, from: bodyParams)
        urlRequest.httpBody = body
      } else {
        fatalError("params cant be empty")
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


