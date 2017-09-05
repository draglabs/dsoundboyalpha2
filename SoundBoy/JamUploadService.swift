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
        session.dataTask(with: prepareURLRequest(reques: request))
    }
    
    private func prepareURLRequest(reques:RequestRepresentable) ->URLRequest {
        
        
        return URLRequest(url: URL(string:"")!)
    }
    
    
  var boundaryString: String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
   private func prepareBody(url:URL) ->Data {
    var bodyData = Data()
    
        
        return Data()
    }
  

}


enum JamUploadRequest:RequestRepresentable {
  
  case soloUpload(userId:String)
  case upload(userId:String, jamId:String)
  var path: String {
    switch self {
    case .soloUpload(let userId):
      return "jam/upload/userid/\(userId)"
      
    case .upload(let userId, let jamId):
      return "jam/upload/userid/\(userId)/\(jamId)"
    }
  }
  
  var method: HTTPMethod { return .post }
  
  /// These are the params we need to send along with the call
  var parameters : RequestParams {
    switch self {
    case .soloUpload(let userId):
      return .body(["user_id":userId])
    case .upload(let userId, let jamId):
      return .body(["user_id":userId,"jamid":jamId])
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
    let uniqueID:String
    let jamID:String
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
         return JamUploadRequest.soloUpload(userId: uniqueID)
      }
      return JamUploadRequest.upload(userId: uniqueID, jamId: jamID)
    }
    
    
  init(uniqueID:String, jamID:String, isSolo:Bool) {
        self.uniqueID = uniqueID
        self.jamID = jamID
        self.isSolo = isSolo
        
    }
    
    
}
