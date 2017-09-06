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
        session.dataTask(with: prepareURLRequest(request: request))
    }
    
    private func prepareURLRequest(request:RequestRepresentable) ->URLRequest {
      
         prepareBody(request: request)
      
        return URLRequest(url: URL(string:"")!)
    }
    
    
  var boundaryString: String {
        return "Boundary-\(NSUUID().uuidString)"
    }
  
  
  private func prepareBody(request:RequestRepresentable) {
    
    switch request.parameters {
    case .body(let json):
      json?.forEach({ (key, value) in
        defaultParams(key: key, value: value as! String)
      })
    default:
      break
    }
    
  }
  
  private func defaultParams(key:String,value:String) {
    
    bodyData.append("--\(boundaryString)\r\n")
    let dispostionKey = "Content-Disposition: form-data; name=\(key)\"\r\n\r\n"
    let dispostionValue = "\(value)\r\n"
    bodyData.append(dispostionKey)
    bodyData.append(dispostionValue)
    audiofilesParams()
  }
    
  private func audiofilesParams() {
    let file = try! Data(contentsOf: fileURL!)
    bodyData.append("--\(boundaryString)\r\n")
    let key = "audio"
    let filename = "audioFile"
    let mimetype = "audio/.caf"
    
    bodyData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
    bodyData.append("Content-Type: \(mimetype)\r\n\r\n")
    bodyData.append(file)
    bodyData.append("\r\n")
    bodyData.append("--\(boundaryString)--\r\n")
    
  }

}


enum JamUploadRequest:RequestRepresentable {
  
  case soloUpload(userId:String)
  case upload(userId:String, jamId:String, start:String, endTime:String)
  var path: String {
    switch self {
    case .soloUpload(let userId):
      return "jam/upload/userid/\(userId)"
      
    case .upload(let userId, let jamId, _ , _ ):
      return "jam/upload/userid/\(userId)/\(jamId)"
    }
  }
  
  var method: HTTPMethod { return .post }
  
  /// These are the params we need to send along with the call
  var parameters : RequestParams {
    switch self {
    case .soloUpload(let userId):
      return .body(["user_id":userId])
    case .upload(let userId, let jamId, let start, let end):
      return .body(["user_id":userId,"jamid":jamId,"startTime":start,"endTime":end])
    }
  
  }
  
  /// these are optional list of headers we can send alogn with the call
  var headers    : [String:Any]? {
  
  let value = "multipart/form-data; boundary=\(NSUUID().uuidString)"
    return [value:"Content-Type"]
  }
  
  /// The kind of data we expect as response
  var dataType   : DataType      { return .JSON }
}


extension JamUpLoadDispatcher:URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("uploading percentage : \(progress)")
        delegate?.currentProgress(progress: progress)
        
    }
  
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let urlResponse = response as! HTTPURLResponse
        let status = urlResponse.statusCode
        delegate?.response(statusCode: status)
    }
  
  
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            delegate?.didFail(error: error)
        }else {
            delegate?.didSucceed()
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
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
