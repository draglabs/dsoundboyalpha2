//
//  MainInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

protocol MainBusinessLogic {
  func startJam(request: Main.Jam.Request)
  func endRecording(request: Main.Jam.Request)
  func exitJam(request: Main.Jam.Request)
  func didJoin(request:Main.Jam.Request)
  func checkForActiveJam(request: Main.Jam.Request)
}

protocol MainDataStore {
  var didJoin:Bool { get set}
}

class MainInteractor: MainBusinessLogic, MainDataStore {
  var presenter: MainPresentationLogic?
  var worker: MainWorker?
  let jamWorker = JamWorker()
  var jamFetcher = JamFetcher()
  var isPlaying = false
  var didJoin: Bool = false
  var isJamActive = false
  
  func checkForActiveJam(request: Main.Jam.Request) {
    self.jamFetcher.fetch(callback: {[unowned self] (jam, error) in
      if let _ = jam {
        self.presenter?.presentJamActive(response: Main.JamActive.Response(isActive: true))
        self.isJamActive = true
      }else {
        self.presenter?.presentJamActive(response: Main.JamActive.Response(isActive: false))
        self.isJamActive = false
      }
    })
  }
  
  func startJam(request: Main.Jam.Request) {
    if isJamActive {
      exitJam(request: Main.Jam.Request())
      return
    }
    jamWorker.startJam() {[unowned self] (result) in
      switch result {
        case .failed(_,_):
          break
        case .success( let data):
          let jam = data as! Jam
          self.presenter?.presentJamPin(response: Main.Jam.Response(pin: jam.pin!))
      }
    }
  }
  

  func exitJam(request: Main.Jam.Request) {
    jamWorker.exitJam {[unowned self] (exited) in
      if exited {
        self.jamFetcher.delete(callback: { (deleted) in
          if deleted {
            self.isJamActive = false
            DispatchQueue.main.async {
             self.presenter?.presentJamActive(response: Main.JamActive.Response(isActive: false))
            }
          }
        })
      }
    }
  }
  
  func uploadJam() {
    worker = MainWorker()
    if let url = Recorder.shared.audioFilename {
        let uploadWorker = JamUploadWorker()
      uploadWorker.uploadJam(url: url, delegate: self)
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
  
  func endRecording(request: Main.Jam.Request) {
    stopRecording()
    uploadJam()
  }
}

extension MainInteractor:JamUpLoadNotifier {
  
  func currentProgress(progress:Float) {
    DispatchQueue.main.async {
    self.presenter?.presentProgress(response: Main.Progress.Response(progress: progress))
    }
  }
  
  func didSucceed() {
    presenter?.presentUploadCompleted(response: Main.JamUpload.Response())
    
  }
  func response(statusCode:Int) {
    print("status code from upload", statusCode)
  }
  func didFail(error:Error?) {
    print("request did fail")
  }
}
