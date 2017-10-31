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
  func startNewRec(request:Main.Jam.Request)
  func endRecording(request: Main.Jam.Request)
  func exitJam(request: Main.Jam.Request)
  func didJoin(request:Main.Jam.Request)
  func checkForActiveJam(request: Main.Jam.Request)
  func exitOrJoin(request:Main.Jam.Request)
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
      startNewRec(request: Main.Jam.Request())
      return
    }
    jamWorker.start() {[unowned self] (result) in
      switch result {
        case .failed(_,_):
          break
        case .success( let data):
          let jam = data as! Jam
          self.startRecording()
          self.presenter?.presentJamPin(response: Main.Jam.Response(pin: jam.pin!))
      }
    }
  }
  
  /// When called directly it will not check
  /// if theres an active jam like `startJam(request:)` does
  /// To start a new Rec call `StartJam(request:)` instead
  func startNewRec(request: Main.Jam.Request) {
    jamFetcher.fetch { (jam, error) in
      guard let j = jam else { return }
      self.startRecording()
      self.presenter?.presentJamPin(response: Main.Jam.Response(pin: j.pin!))
      }
    
  }
  func exitOrJoin(request: Main.Jam.Request) {
    if isJamActive {
      exitJam(request: Main.Jam.Request())
    }else {
      self.presenter?.presentToReroute(viewModel: Main.Join.ViewModel())
    }
  }
  func exitJam(request: Main.Jam.Request) {
    jamWorker.exit {[unowned self] (exited) in
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
    
    if didJoin {
      startRecording()
      self.presenter?.presentJamJoin(response: Main.Join.Response())
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
    checkForActiveJam(request: Main.Jam.Request())
  }
  func response(statusCode:Int) {
   
  }
  func didFail(error:Error?) {
   presenter?.presentUploadCompleted(response: Main.JamUpload.Response())
  }
}
