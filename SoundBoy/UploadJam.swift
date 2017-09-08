//
//  JamUploadServices.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/1/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation


protocol JamUpLoadNotifier {
    func currentProgress(progress:Float)
    func didSucceed()
    func response(statusCode:Int)
    func didFail(error:Error?)
}

enum JamUploadRequest:RequestRepresentable {
  
  case soloUpload(userId:String)
  case upload(userId:String, jamId:String, start:String, endTime:String)
  
  var method: HTTPMethod { return .post }
  var dataType: DataType{ return .JSON }
  
  var path: String {
    switch self {
    case .soloUpload(let userId):
      return "jam/upload/userid/\(userId)"
      
    case .upload(let userId, let jamId, _ , _ ):
      return "jam/upload/userid/\(userId)/jamid/\(jamId)"
    }
  }
  
  
  var parameters : RequestParams {
    switch self {
    case .soloUpload(let userId):
      return .body(["user_id":userId])
    case .upload( _,  _, let start, let end):
      return .body(["startTime":start,"endTime":end])
    }
    
  }
  
  
  var headers: [String:Any]? {
    
    let value = "multipart/form-data; boundary=—-\(boundaryString)"
    return [value:"Content-Type"]
  }
  
  
  var boundaryString: String {
    
    return String(format: "draglabs.boundary.%08x%08x", arc4random(), arc4random())
  }
  
  
}

class JamUpLoadDispatcher:NSObject, DispatcherRepresentable {
    let enviroment:Enviroment
    
    var fileURL:URL?
    var bodyData = Data()
    var delegate:JamUpLoadNotifier?
    var results:((_ response:Response)->())?
    var session:URLSession {
       let config = URLSessionConfiguration.default
      
        let s = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        return s
    }
    
    //MARK:TODO unused conformance, will refactor for multipart-form
    func execute(request: RequestRepresentable, result: @escaping (Response) -> ()) {
        self.results = result
    
    }
        required init(enviroment: Enviroment) {
        self.enviroment = enviroment
        
    }
    
    convenience init(enviroment:Enviroment,fileURL:URL,delegate:JamUpLoadNotifier) {
        self.init(enviroment:enviroment)
        self.delegate = delegate
        self.fileURL = fileURL
        
    }
    
    func executeUpload(request:RequestRepresentable) {
      // session.dataTask(with:prepareURLRequest(request: request)).resume()
     
        session.dataTask(with: prepareURLRequest(request: request)) { (data, respose, err) in
          if let data = data {
             let js  = try! JSONSerialization.jsonObject(with: data, options: [])
            print(js)
          }
         
          
      }.resume()
      
    }
    
    private func prepareURLRequest(request:RequestRepresentable) ->URLRequest {
      let url = "\(enviroment.host)/\(request.path)"
      var urlRequest = URLRequest(url: URL(string:url)!)
      
      request.headers?.forEach({ (value, field) in
        urlRequest.addValue(value, forHTTPHeaderField: field as! String)
      })
    
      prepareBody(request: request)
      urlRequest.httpBody = bodyData
      urlRequest.httpMethod = request.method.rawValue
      
      
        return urlRequest
    }
  

    
  var boundaryString: String {
    
      return String(format: "draglabs.boundary.%08x%08x", arc4random(), arc4random())
    }
  
  
  private func prepareBody(request:RequestRepresentable) {
    
    switch request.parameters {
    case .body(let params):
        audiofilesParams(params: params!)
     
    default:
      break
    }
  
    
  }
  

  private func audiofilesParams(params:JSONDictionary) {
        let key      = "audioFile"
        let filename = "track.caf"
        let mimetype = "audio/x-caf"
        let data =  try! Data(contentsOf: fileURL!)
    
    for (key, val) in params {
      let value = val as! String
    
      bodyData.append("--\(boundaryString)\r\n")
      bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
      bodyData.append("\(value)\r\n")
      
    }
    
    bodyData.append("--\(boundaryString)\r\n")
    bodyData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
    bodyData.append("Content-Type: \(mimetype)\r\n\r\n")
    bodyData.append(data)
    bodyData.append("\r\n")
    bodyData.append("--\(boundaryString)--\r\n")
   
    
  }

}


extension JamUpLoadDispatcher:URLSessionDataDelegate,URLSessionTaskDelegate  {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("uploading percentage : \(progress)")
        delegate?.currentProgress(progress: progress)
        
    }
  
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let urlResponse = response as! HTTPURLResponse
        let status = urlResponse.statusCode
        print(urlResponse)
      
        delegate?.response(statusCode: status)
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


class JamUploadOperation: OperationRepresentable {
  let jam:Jam
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
         return JamUploadRequest.soloUpload(userId: userId)
      }
      return JamUploadRequest.upload(userId: userId, jamId: jam.id!, start: jam.startTime!, endTime: jam.endTime!)
    }
    
    
  init(userId:String, jam:Jam, isSolo:Bool) {
        self.userId = userId
        self.jam = jam
        self.isSolo = isSolo
        
    }
    
    
}
