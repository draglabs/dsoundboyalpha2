//
//  JamUploadServices.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/1/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol JamUpLoadNotifier {
    func currentProgress(progress:Float)
    func didSucceed()
    func response(statusCode:Int)
    func didFail(error:Error?)
}

enum JamUploadRequest:RequestRepresentable {
  
  case soloUpload(userId:String, startTime:String, endTime:String)
  case upload(userId:String, jamId:String, start:String, endTime:String)
  
  var method: HTTPMethod { return .post }
  var dataType: DataType{ return .JSON }
  
  var path: String {
    switch self {
    case .soloUpload(let userId,_,_):
      return "soloupload/userid/\(userId)"
      
    case .upload(let userId, let jamId, _ , _ ):
      return "jam/upload/userid/\(userId)/jamid/\(jamId)"
    }
  }
  
  var parameters : RequestParams {
    switch self {
    case .soloUpload(_,let start,let end):
      return .body(["startTime":start,"endTime":end])
    case .upload( _,  _, let start, let end):
      return .body(["startTime":start,"endTime":end])
     }
  }
  var headers: [String:Any]? {
    
    return ["multipart/form-data; boundary=\(boundaryString)":"Content-Type"]
  }
  
  var boundaryString: String {
    return "Boundary-\(NSUUID().uuidString)"
  }

}

class JamUpLoadDispatcher:NSObject, DispatcherRepresentable {
    let enviroment:Enviroment
    
    var fileURL:URL?
    let boundary = "Boundary-\(NSUUID().uuidString)"
    var bodyData = Data()
    var delegate:JamUpLoadNotifier?
    var results:((_ response:Response)->())?
  
  
    var session:URLSession {
       let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }
  
  required init(enviroment: Enviroment) {
    self.enviroment = enviroment
    
  }
    func execute(request: RequestRepresentable, result: @escaping (Response) -> ()) {
        self.results = result
    }
  
    convenience init(enviroment:Enviroment,fileURL:URL,delegate:JamUpLoadNotifier) {
        self.init(enviroment:enviroment)
        self.delegate = delegate
        self.fileURL = fileURL
    }
    
    func executeUpload(request:RequestRepresentable) {
       session.dataTask(with:prepareURLRequest(request: request)).resume()
//      session.dataTask(with: prepareURLRequest(request: request), completionHandler: { (data, response, error) in
//        let parser = Parser()
//        print(parser.parse(to: .json, from: data) ?? "Cant parse data from uploading")
//      }).resume()
    }
    
    private func prepareURLRequest(request:RequestRepresentable) ->URLRequest {
      var urlRequest = URLRequest(url: URL(string: "\(enviroment.host)/\(request.path)")!)
      urlRequest.httpMethod = request.method.rawValue
      urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      urlRequest.httpBody = prepareBody(request: request)
      
        return urlRequest
    }
  

  private func prepareBody(request:RequestRepresentable) ->Data {
    var body = Data()
    switch request.parameters {
    case .body(let json):
      body.append(buildBodyParams(params: json!))
    default:
      break
    }
      let date = Date()
      let fileKey = "audioFile"
      let filename = "track.caf-\(date)"
      let data = try! Data(contentsOf: fileURL!)
      let mimetype = mimeType(for: fileURL!.path)
      print(fileURL!.path)
      body.append("--\(boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(filename)\"\r\n")
      body.append("Content-Type: \(mimetype)\r\n\r\n")
      body.append(data)
      body.append("\r\n")
    
    body.append("--\(boundary)--\r\n")
    return body
  }

  
  func buildBodyParams(params:JSONDictionary) ->Data {
    var body = Data()
    
      for (key, value) in params {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }
    return body
  }
  
  
  func mimeType(for path: String) -> String {
    let url = NSURL(fileURLWithPath: path)
    let pathExtension = url.pathExtension
    
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
      if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
        print(mimetype)
        return mimetype as String
      }
    }
    
    return "application/octet-stream";
  }
}

extension JamUpLoadDispatcher:URLSessionDataDelegate,URLSessionTaskDelegate  {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        delegate?.currentProgress(progress: progress)
        
    }
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let urlResponse = response as! HTTPURLResponse
        let status = urlResponse.statusCode
        delegate?.response(statusCode: status)
        if status == 200 || status < 300 {
          delegate?.didSucceed()
        }else {
          delegate?.didFail(error: nil)
      }
    }
  
  
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
          print(error)
            delegate?.didFail(error: error)
        }else {
            delegate?.didSucceed()
        }
    }
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("did received data", data)
    }

}


class JamUpload: OperationRepresentable {
  var jam:Jam?
  let userId:String
  let isSolo:Bool
    var responseError:((_ code:Int?, _ error:Error?)->())?
    var store: StoreRepresentable {
        return JamStore()
    }
    
    
    func execute(in dispatcher: DispatcherRepresentable, result: @escaping(_ uploaded:Bool)->()) {
      
        dispatcher.execute(request: request) { (response) in
            switch response {
            case .data(let data):
                self.store.fromData(data: data,response: result)
            case .json(let json):
                self.store.fromJSON(json: json, response: result)
            case .error(let statuscode, let error):
                self.responseError?(statuscode,error)
                result(false)
            }
        }
    }
  
  
  func executeUpload(in dispatcher:JamUpLoadDispatcher) {
    dispatcher.executeUpload(request: request)
    
  }
  
    var request: RequestRepresentable {
      if isSolo {
        return JamUploadRequest.soloUpload(userId: userId, startTime: "3034:405", endTime: "405:405")
      }
      return JamUploadRequest.upload(userId: userId, jamId: jam!.id!, start: jam!.startTime!, endTime: jam!.endTime!)
    }
  
  init(userId:String, jam:Jam?, isSolo:Bool) {
        self.userId = userId
        self.jam = jam
        self.isSolo = isSolo
    }
}


class JamUploadWorker {
  
  let env = Enviroment("production", host: "http://api.draglabs.com/v1.01")
  let userFetcher = UserFether()
  let jamFetcher = JamFetcher()
  var uploadDelegate:JamUpLoadNotifier?
  var isSolo = false
  
  func uploadJam(url:URL, delegate:JamUpLoadNotifier, isSolo:Bool) {
      self.uploadDelegate = delegate
    self.isSolo = isSolo
    if isSolo {
      userFetcher.fetch { (user, error) in
        if user != nil {
          self.prepareSolo(user: user!.userId!, url: url, delegate: delegate)
        }
      }
      
      return
    }
      userFetcher.fetch { (user, error) in
        if user != nil {
          self.prepareUser(user: user!,url: url)
        }
      }
    }
  
  private func prepareUser(user:User, url:URL) {
      let userId = user.userId!
  
      jamFetcher.fetch { (jam, error) in
        if jam != nil {
          self.prepareJam(jam: jam!, userId: userId, url:url)
        }
      }
    }

  
  private func prepareJam(jam:Jam,userId:String, url:URL) {
      let uploadDispatcher = JamUpLoadDispatcher(enviroment:env, fileURL: url, delegate: uploadDelegate!)
      let task = JamUpload(userId: userId, jam: jam, isSolo: isSolo)
      task.executeUpload(in: uploadDispatcher)
    }
  
  
  private func prepareSolo(user:String,url:URL, delegate:JamUpLoadNotifier) {
    let uploadDispatcher = JamUpLoadDispatcher(enviroment:env, fileURL: url, delegate: uploadDelegate!)
    let task = JamUpload(userId: user, jam: nil, isSolo: isSolo)
    task.executeUpload(in: uploadDispatcher)
  }
}

