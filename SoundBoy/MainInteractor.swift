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
  func endRecording(request: Main.Jam.Request)
  func exitJam(request: Main.Jam.Request)
  func didJoin(request:Main.Jam.Request)
}

protocol MainDataStore {
  var didJoin:Bool { get set}
}

class MainInteractor: MainBusinessLogic, MainDataStore {
  var presenter: MainPresentationLogic?
  var worker: MainWorker?
  var jamFetcher = JamFetcher()
  var isPlaying = false
  var didJoin: Bool = false
  
  func startJam(request: Main.Jam.Request) {
     worker = MainWorker()
    
    jamFetcher.fetch { (jam, error) in
      if jam == nil {
        self.startJamWhen()
      }else {
        print("Jam already in place")
      }
    }
    
  }
  
  func endRecording(request: Main.Jam.Request) {
     uploadJam()
  }
  
  func startJamWhen() {
    worker?.startJamRequest() { (done) in
      if done {
        self.jamFetcher.fetch(callback: { (jam, error) in
          if let jam = jam {
            self.presenter?.presentJamPin(jam: jam)
          }
        })
      }else {
        print("no done")
      }
    }
  }
  
  
  func exitJam(request: Main.Jam.Request) {
    worker = MainWorker()
  }
  
  func uploadJam() {
    worker = MainWorker()
    if let url = Recorder.shared.audioFilename {
        let uploadWorker = JamUploadWorker()
        uploadWorker.uploadJam(url: url, delegate: self)
        presenter?.presentCurrentRecordEnded()
    }
    
  }
  func didJoin(request: Main.Jam.Request) {
    if self.didJoin {
      startRecording()
      
    }
  }
  private func startRecording() {
    Recorder.shared.startRecording()
  }
  private func stopRecording() {
    Recorder.shared.stopRecording()
  }
}

extension MainInteractor:JamUpLoadNotifier {
  func currentProgress(progress:Float) {
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
