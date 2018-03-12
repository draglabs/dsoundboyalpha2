//
//  MainInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import Foundation

protocol MainBusinessLogic {
  func new(request: Main.Jam.Request)
  func rec(request:Main.Jam.Request)
  func endRecording(request: Main.Jam.Request)
  func didJoin(request:Main.Jam.Request)
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
  
  func new(request: Main.Jam.Request) {
    delete {
          self.jamWorker.start() {[unowned self] (result) in
            switch result {
              case .failed(_,_):
                break
              case .success:
                self.jamFetcher.fetch { (jam, error) in
                  guard let j = jam else { return }
                  self.startRecording()
                  var pin = ""
                  if j.pin != nil{pin = j.pin!}
                  self.presenter?.presentJam(response: Main.Jam.Response(pin: pin))
              }
            }
        }
    }

  }
  private func delete(block:@escaping ()->()) {
    jamFetcher.delete { (deleted) in
      print("Deleted",deleted)
      block()
    }
  }
  
  func rec(request: Main.Jam.Request) {
    self.jamFetcher.fetch { (jam, error) in
      guard let j = jam else { return }
      self.startRecording()
      var pin = ""
      if j.pin != nil{pin = j.pin!}
      self.presenter?.presentJam(response: Main.Jam.Response(pin: pin))
      
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
    if didJoin {
      self.jamFetcher.fetch { (jam, error) in
        guard let j = jam else { return }
        self.startRecording()
        var pin = ""
        if j.pin != nil{pin = j.pin!}
        self.presenter?.presentJam(response: Main.Jam.Response(pin: pin))
      }
      didJoin = false
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
   
  }
  func didFail(error:Error?) {
   presenter?.presentUploadCompleted(response: Main.JamUpload.Response())
  }
}
