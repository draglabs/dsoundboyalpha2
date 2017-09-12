//
//  MainInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol MainBusinessLogic {
  func startJam(request: Main.Jam.Request)
  func settings(request:Main.Jam.Request)
  func files( request:Main.Jam.Request)
  func uploadJam(request:Main.JamUpload.Request)
}

protocol MainDataStore {
  var success: Bool { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
  var presenter: MainPresentationLogic?
  var worker: MainWorker?
  
  var success: Bool = false
  // MARK: Do something
  
  func startJam(request: Main.Jam.Request) {
     worker = MainWorker()
     worker?.startJamRequest() { (done) in
      print(done)
    }
  }
  
  func uploadJam(request: Main.JamUpload.Request) {
     worker = MainWorker()
    worker?.uploadJam(url: request.fileURL, delegate: self)
    
  }
 func settings(request: Main.Jam.Request) {
  
     
  }
  
 func files(request: Main.Jam.Request) {
  
        
  }
}

extension MainInteractor:JamUpLoadNotifier {
  func currentProgress(progress:Float) {
    print("current upload", progress)
    presenter?.presentProgress(progress: progress)
  }
  
  func didSucceed() {
    print("requesst succeeded")
  }
  func response(statusCode:Int) {
    print("status code from upload", statusCode)
  }
  func didFail(error:Error?) {
    
  }
}
